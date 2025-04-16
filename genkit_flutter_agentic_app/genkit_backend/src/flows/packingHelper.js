import { z } from 'genkit';
import { ai } from "../ai.js";
import { getWeatherTool } from "../tools/weather.js";
import { getLatLongTool } from "../tools/latlong.js";
import { getUnsplashTool } from '../tools/unsplash.js';
import { gemini20Flash } from '@genkit-ai/googleai';

//  INPUT Schema from client
const PackingHelperInputSchema = z.object({
    numberOfDays: z.number().describe('Number of days that the traveler is traveling'),
    location: z.string().describe('The location where the traveler is going'),
    preferences: z.string().describe('The traveler\'s packing preferences when it comes to what they like to wear / pack for their vacation'),
});

// OUTPUT Schema send to client
const ArticleOfClothingSchema = z.object({
    name: z.string().describe('Name of the article of clothing'),
    quantity: z.number().describe('Quantity of this item needed.'),
    dates: z.array(z.string().describe('dates when this article of clothing is applicable')),
    notes: z.string().optional().describe('Any additional notes for the user.'),
    optional: z.boolean().describe('Whether or not this item is optional')
});

const PackingChecklistSchema = z.object({
    items: z.array(ArticleOfClothingSchema).describe('The items that need to be packed'),
});

// PACKING HELPER FLOW
// INPUT: Provide the location that you're visiting, number of days, and any attire preferences.
// Output: Get the weather forecast, a hero image, and packing checklist for that location
export const packingHelperFlow = ai.defineFlow(
    {
        name: 'packingHelperFlow',
        inputSchema: PackingHelperInputSchema,
    },
    async (input) => {
        // Data scheme for weather forecast in a given location
        const WeatherSchema = z.object({
            location: z.object({
                city: z.string().describe('The name of the city where the traveler is going'),
                state: z.string().describe('The name of the state or province where the traveler is going')
            }),
            weatherForecast: z.string().describe(`The weather forecast for the specified location. Include the temperature range.`),
        });

        const weatherResponse = await ai.generate({
            prompt: `What is the weather forecast for ${input.location}? Once you have the weather information, please write a summary the forecast for the next ${input.numberOfDays} days in 2 sentences.`,
            tools: [getWeatherTool, getLatLongTool],
            model: gemini20Flash,
            output: {
                schema: WeatherSchema,
            },
        });

        const location = weatherResponse.output.location;
        const weather = weatherResponse.output.weatherForecast;

        // Data scheme to store daily outfit plans.
        const OutfitPlannerSchema = z.array(z.object({
            date: z.string().describe('The date this outfit should be worn.'),
            outfit: z.string('A description of the outfit to be worn with an itemized list of articles of clothing.')
        }));

        const outfitsResponse = await ai.generate({
            system: 'You are an expert personal stylist. A traveler has asked you to put together outfits for them to wear for an upcoming travel trip. You curate outfits based on the weather and the traveler\'s preferences.',
            prompt: `Using your fashion expertise, please create an itemized list of ${input.numberOfDays} outfits that the user should pack for the weather forecast: ${weather} and matches the traveler's attire preferences: ${input.preferences}. 
            Follow these rules: 
            - Every outfit needs to have at least a top (tshirt, shirt, sweater.) and bottom (pants, jeans, sweatpants, skirt.) unless the outfit is a dress. 
            - Layers are allowed, so 
            - If it's cold or raining, the traveler will need a jacket that can be worn for multiple days.
            - If it's sunny, suggest sunglasses and a hat.`,
            config: {
                maxOutputTokens: 400,
                stopSequences: ['<end>', '<fin>'],
                temperature: 1.2,
                topP: 0.4,
                topK: 50,
            },
            output: { schema: OutfitPlannerSchema },
        });

        const outfits = outfitsResponse.output;

        const checklistResponse = await ai.generate({
            prompt: `Analyze this list of outfits: ${JSON.stringify(outfits)} and create a consolidated checklist of items that the user needs to pack. Aggregate common items and provide the exact item count needed.`,
            output: { schema: PackingChecklistSchema },
            model: gemini20Flash,
            config: {
                temperature: 1,
            },
        });

        const checklist = checklistResponse.output;

        const heroImageResponse = await ai.generate({
            prompt: `Get JUST the URL to an image of the travel destination: ${input.location} as a string. Use a search query that wil return an image of a popular tourist attraction in ${location.city},${location.state}. If there is no famous attraction, find an image of the ${location.city} skyline.`,
            tools: [getUnsplashTool],
            model: gemini20Flash,
            output: z.string().describe(`URL to an image of ${input.location}`)
        });

        const heroImage = heroImageResponse.text;

        return {
            location: location,
            lengthOfStay: input.numberOfDays,
            weather: weather,
            heroImage: heroImage,
            checklist: checklist
        };
    });