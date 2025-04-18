import { ai } from "../ai.js";
import { z } from 'genkit';

// Ensure that you set the OpenWeather API key as an environment variable
import { OPEN_WEATHER_API_KEY } from '../config.js';

// Makes an API Call to the OpenWeather 5 day / 3 hour forecast API
// and returns an object with {latitude, longitude}
// https://openweathermap.org/api/geocoding-api

async function getWeather(lat, lon, days) {
    if (!OPEN_WEATHER_API_KEY) {
        throw new Error('OpenWeather API Key is missing. Please set the OPEN_WEATHER_API_KEY environment variable.');
    }

    const url = `https://api.openweathermap.org/data/2.5/forecast/daily?lat=${lat}&lon=${lon}&cnt=${days}&units=imperial&appid=${OPEN_WEATHER_API_KEY}`;

    try {
        const response = await fetch(url);
        const data = await response.json();
        const weatherResponse = JSON.stringify(data);
        console.log("Called Weather Tool!");

        const { text } = await ai.generate(`
            Summarize this weather forecast data with a description for each day in the following format:
            Here is the JSON data: 
            <start of JSON data>
            ${weatherResponse}
            </end of JSON data>
            
            Here is a description of the JSON data format: 
            <start JSON data format descriptions>
            list
            list.dt Time of data forecasted
            list.temp
            list.temp.day Temperature at 12:00 local time. Unit: Fahrenheit
            list.temp.min Min daily temperature. Unit: Fahrenheit
            list.temp.max Max daily temperature. Unit: Fahrenheit
            list.temp.night Temperature at 00:00 local time. Unit: Fahrenheit
            list.temp.eve Temperature at 18:00 local time. Unit: Fahrenheit
            list.temp.morn Ttemperature at 06:00 local time. Unit: Fahrenheit
            list.feels_like
            list.feels_like.day Temperature at 12:00 local time.This temperature parameter accounts for the human perception of weather. Unit: Fahrenheit
            list.feels_like.night Temperature at 00:00 local time.This temperature parameter accounts for the human perception of weather. Unit: Fahrenheit
            list.feels_like.eve Temperature at 18:00 local time.This temperature parameter accounts for the human perception of weather. Unit: Fahrenheit
            list.feels_like.morn Temperature at 06:00 local time. This temperature parameter accounts for the human perception of weather. Unit: Fahrenheit
            list.pressure Atmospheric pressure on the sea level, hPa
            list.humidity Humidity, %
            list.weather (more info Weather condition codes)
            list.weather.id Weather condition id
            list.weather.main Group of weather parameters (Rain, Snow, Clouds etc.)
            list.weather.description Weather condition within the group. Please find more here. You can get the output in your language. Learn more
            list.weather.icon Weather icon id
            list.speed Maximum wind speed for the day. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
            list.deg Wind direction relevant to the maximum wind speed, degrees (meteorological)
            list.gust Wind gust. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
            list.clouds Cloudiness, %
            list.rain Precipitation volume, mm. Please note that only mm as units of measurement are available for this parameter
            list.snow Snow volume, mm. Please note that only mm as units of measurement are available for this parameter
            list.pop Probability of precipitation. The values of the parameter vary between 0 and 1, where 0 is equal to 0%, 1 is equal to 100%
            </end JSON data format descriptions>
        `);

        return text;
    } catch (error) {
        return console.error("Error fetching weather data:", error);
    }
}

// Define a Genkit tool to get the weather for a given latitude and logitude
export const getWeatherTool = ai.defineTool({
    name: 'getWeather',
    description: 'Use this tool to get the weather forecast for the next {{number of days}} in {{location specified by latitude and longitude}}.',
    inputSchema: z.object({
        lat: z.number().describe('The latitude of the location to get the weather forecast.'),
        long: z.number().describe('The longitude of the location to get the weather forecast.'),
        days: z.number().describe('Number of days to get the weather forecast'),
    }),
    output: {
        schema: z.array(
            z.object({
                day: z.string().describe('Date of the forecast in the format of: Day, Month Date, Year'),
                low: z.number().describe('Low temperature for the day'),
                high: z.number().describe('High temperature for the day'),
                humidity: z.number().describe('Humidity, %'),
                weather_condition: z.string().describe('A brief description of the weather condition, such as cloudy, sunny, rain, snow, etc.')
            },).describe('The weather forecast for a day.'),
        ).describe('The weather forecast for the specified location.')
    },
}, async (input) => await getWeather(input.lat, input.long, input.days));



/* <Start output format>
This is the weather forecast for the next 5 days:

Date: <Date of the forecast in the format of: Day, Month Date, Year>
- Low Temperature: <Low temperature for the day>
- High Temperature: <High temperature for the day>
- "Feels like" Temperature: <Feels like temperature range throughout the day>
- Weather condition: <A brief description of the weather condition, such as cloudy, sunny, rain, snow, etc.>
</end output format>

Here's an example:
Friday, April 18, 2025
- Low Temperature: 60°F
- High Temperature: 80°F
- "Feels like" Temperature: 58°F - 81°F
- Weather condition: Mostly cloudy with a chance of rain.
 */