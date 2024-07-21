package in.sp.backend;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.util.Scanner;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LonLatServlet")
public class LonLatServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public LonLatServlet() {
        super();
    }

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 System.out.println("doGetCalled");
		    String apiKey = "13ccdc0ab4b754511d4861cf23e18a56";
		    String latitude = request.getParameter("Latitude");
		    String longitude = request.getParameter("Longitude");
		    
		    System.out.println("Latitude received: " + latitude + ", Longitude received: " + longitude);

		    String apiUrl = "https://api.openweathermap.org/data/2.5/weather?lat=" + latitude + "&lon=" + longitude + "&appid=" + apiKey;

			try {
				URL url = new URL(apiUrl);
				HttpURLConnection connection = (HttpURLConnection) url.openConnection();
				connection.setRequestMethod("GET");
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

				 response.setContentType("application/json");
		            response.setCharacterEncoding("UTF-8");
		            response.getWriter().print(jsonObject);
		            response.setStatus(HttpServletResponse.SC_OK); // Ensure status is OK

		            connection.disconnect();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}
