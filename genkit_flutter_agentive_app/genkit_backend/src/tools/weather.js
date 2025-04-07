import { ai } from "../ai.js";
import { z } from 'genkit';

// Ensure that you set the OpenWeather API key as an environment variable
import { OPEN_WEATHER_API_KEY } from '../config.js';

// Makes an API Call to the OpenWeather 5 day / 3 hour forecast API
// and returns an object with {latitude, longitude}
// https://openweathermap.org/api/geocoding-api

async function getWeather(lat, lon) {
    if (!OPEN_WEATHER_API_KEY) {
        throw new Error('OpenWeather API Key is missing. Please set the OPEN_WEATHER_API_KEY environment variable.');
    }

    const url = `https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&appid=${OPEN_WEATHER_API_KEY}`;

    try {
        const response = await fetch(url);
        const data = await response.json();
        const weatherResponse = JSON.stringify(data);
        const { text } = await ai.generate(`Describe this weather forecast data for each day. Include a brief description of the day, low, high, feels like, and weather condition such as cloudy, sunny, rain, snow, etc. Specify temperatures in Farenheit. ${weatherResponse}.`);
        return text;
    } catch (error) {
        return console.error("Error fetching weather data:", error);
    }
}

// Define a Genkit tool to get the weather for a given latitude and logitude
export const getWeatherTool = ai.defineTool({
    name: 'getWeather',
    description: 'Get the weather information at a location for the next 5 days.',
    inputSchema: z.object({ lat: z.number(), long: z.number() }).describe('The location to get the current weather for, as defined by latitude and longitude.'),
    output: { schema: z.string().describe('A summary of the weather forecast.') },
}, async (input) => await getWeather(input.lat, input.long, input.when));