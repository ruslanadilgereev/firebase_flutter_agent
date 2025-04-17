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

    const url = `https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&units=imperial&appid=${OPEN_WEATHER_API_KEY}`;

    try {
        const response = await fetch(url);
        const data = await response.json();
        data['list'].forEach(element => {
            console.log(element);
        });
        const weatherResponse = JSON.stringify(data);
        const { text } = await ai.generate(`
            Summarize this weather forecast data with a description for each day in the following format:
            <Start output format>
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
            
            Here is the JSON data: 
            <start of JSON data>
            ${weatherResponse}
            </end of JSON data>
            
            Here is a description of the JSON data format: 
            <start JSON data format descriptions>
            list
            list.dt Time of data forecasted, unix, UTC
            list.main.temp Temperature. Unit: Fahrenheit
            list.main.feels_like This temperature parameter accounts for the human perception of weather. Unit: Fahrenheit
            list.main.temp_min Minimum temperature at the moment of calculation. This is minimal forecasted temperature (within large megalopolises and urban areas), use this parameter optionally. Unit: Fahrenheit
            list.main.temp_max Maximum temperature at the moment of calculation. This is maximal forecasted temperature (within large megalopolises and urban areas), use this parameter optionally. Unit: Fahrenheit
            list.main.pressure Atmospheric pressure on the sea level by default, hPa
            list.main.sea_level Atmospheric pressure on the sea level, hPa
            list.main.grnd_level Atmospheric pressure on the ground level, hPa
            list.main.humidity Humidity, %
            list.main.temp_kf Internal parameter
            list.weather
            list.weather.id Weather condition id
            list.weather.main Group of weather parameters (Rain, Snow, Clouds etc.)
            list.weather.description Weather condition within the group.
            list.weather.icon Weather icon id
            list.clouds
            list.clouds.all Cloudiness, %
            list.wind
            list.wind.speed Wind speed. Unit: Imperial: miles/hour
            list.wind.deg Wind direction, degrees (meteorological)
            list.wind.gust Wind gust. Unit: miles/hour
            list.visibility Average visibility, metres. The maximum value of the visibility is 10km
            list.pop Probability of precipitation. The values of the parameter vary between 0 and 1, where 0 is equal to 0%, 1 is equal to 100%
            list.rain
            list.rain.3h Rain volume for last 3 hours, mm. Please note that only mm as units of measurement are available for this parameter
            list.snow
            list.snow.3h Snow volume for last 3 hours. Please note that only mm as units of measurement are available for this parameter
            list.sys
            list.sys.pod Part of the day (n - night, d - day)
            list.dt_txt Time of data forecasted, ISO, UTC
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
    description: 'Get the weather information at a location for the next 5 days.',
    inputSchema: z.object({ lat: z.number(), long: z.number() }).describe('The location to get the current weather for, as defined by latitude and longitude.'),
    output: { schema: z.string().describe('A summary of the weather forecast.') },
}, async (input) => await getWeather(input.lat, input.long, input.when));