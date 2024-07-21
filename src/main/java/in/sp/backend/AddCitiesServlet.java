package in.sp.backend;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddCities")
public class AddCitiesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private List<String> cityList;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		List<String> cityList = new ArrayList<>();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			fetchCitiesFromDatabase(cityList);
			String json = new Gson().toJson(cityList);
			response.getWriter().write(json);
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"errorMessage\": \"Error fetching city data: " + e.getMessage() + "\"}");
		}
	}
	
	private void fetchCitiesFromDatabase(List<String> cityList) throws SQLException {
		String dbUrl = "jdbc:mysql://localhost:3306/weather_demo";
		String dbUser = "root";
		String dbPassword = "ROOT";

		try (Connection connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
			String sql = "SELECT name FROM city";
			try (PreparedStatement statement = connection.prepareStatement(sql);
					ResultSet resultSet = statement.executeQuery()) {
				while (resultSet.next()) {
					cityList.add(resultSet.getString("name"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String newCity = request.getParameter("city");
		System.out.println(newCity + "is tried to added");
		try {
			if (newCity != null && !newCity.trim().isEmpty()) {
				if (!isCityExists(newCity)) {
					addCityToDatabase(newCity);
				} else {
					System.out.println("City already exists: " + newCity);
				}
			}
		} catch (Exception e) {
			request.setAttribute("errorMessage", "Error adding city: " + e.getMessage());
		}
	}
	
	private boolean isCityExists(String cityName) throws SQLException {
		String dbUrl = "jdbc:mysql://localhost:3306/weather_demo";
		String dbUser = "root";
		String dbPassword = "ROOT";

		try (Connection connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
			String sql = "SELECT COUNT(*) FROM city WHERE name = ?";
			try (PreparedStatement statement = connection.prepareStatement(sql)) {
				statement.setString(1, cityName);
				try (ResultSet resultSet = statement.executeQuery()) {
					if (resultSet.next()) {
						return resultSet.getInt(1) > 0;
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
		return false;
	}
	
	private void addCityToDatabase(String CityName) throws SQLException {
		String dbUrl = "jdbc:mysql://localhost:3306/weather_demo";
		String dbUser = "root";
		String dbPassword = "ROOT";

		try (Connection connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
			String sql = "INSERT INTO citY (name) VALUES (?)";
			try (PreparedStatement statement = connection.prepareStatement(sql)) {
				statement.setString(1, CityName);
				statement.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
	}
}