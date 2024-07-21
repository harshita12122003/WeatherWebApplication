package in.sp.backend;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Scanner;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet("/DummyServlet")
public class dummyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    System.out.println("doPostCalled");
	    String apiKey = "13ccdc0ab4b754511d4861cf23e18a56";
	    String city = request.getParameter("city");
	    
	    System.out.println("city received: " + city); // Verify if city is received correctly
	    
	    if (city != null && !city.isEmpty()) {
	        String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + URLEncoder.encode(city, StandardCharsets.UTF_8.toString()) + "&appid=" + apiKey;

	        try {
	            URL url = new URL(apiUrl);
	            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	            connection.setRequestMethod("POST"); // Use GET for OpenWeatherMap API
	            connection.setRequestProperty("Content-Type", "application/json");

	            InputStream inputStream = connection.getInputStream();
	            InputStreamReader reader = new InputStreamReader(inputStream);

	            Scanner scanner = new Scanner(reader);
	            StringBuilder responseContent = new StringBuilder();

	            while (scanner.hasNext()) {
	                responseContent.append(scanner.nextLine());
	            }
	            scanner.close();

	            Gson gson = new Gson();
	            JsonObject jsonObject = gson.fromJson(responseContent.toString(), JsonObject.class);

	            long dateTimestamp = jsonObject.get("dt").getAsLong() * 1000;
	            String date = new Date(dateTimestamp).toString();

	            // Temperature
	            double temperatureKelvin = jsonObject.getAsJsonObject("main").get("temp").getAsDouble();
	            int temperatureCelsius = (int) (temperatureKelvin - 273.15);

	            // Humidity
	            int humidity = jsonObject.getAsJsonObject("main").get("humidity").getAsInt();

	            // Wind Speed
	            double windSpeed = jsonObject.getAsJsonObject("wind").get("speed").getAsDouble();

	            // Weather Condition
	            String weatherCondition = jsonObject.getAsJsonArray("weather").get(0).getAsJsonObject().get("main").getAsString();

	            // Create JSON response object
	            JsonObject responseData = new JsonObject();
	            responseData.addProperty("date", date);
	            responseData.addProperty("city", city);
	            responseData.addProperty("temperature", temperatureCelsius);
	            responseData.addProperty("weatherCondition", weatherCondition);
	            responseData.addProperty("humidity", humidity);
	            responseData.addProperty("windSpeed", windSpeed);

	            // Send JSON response
	            response.setContentType("application/json");
	            response.setCharacterEncoding("UTF-8");
	            response.getWriter().write(responseData.toString());

	            connection.disconnect();
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    } else {
	        // Handle case where city parameter is not provided
	        System.out.println("City parameter is null or empty.");
	    }
	}

}
