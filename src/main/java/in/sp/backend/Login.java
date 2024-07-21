package in.sp.backend;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class Login extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");

		PrintWriter out = response.getWriter();

		String myUserId = request.getParameter("email");
		String myPassword = request.getParameter("password");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/weather_demo", "root", "ROOT");

			PreparedStatement ps = con.prepareStatement("select * from login where email=? and password=?");
			ps.setString(1, myUserId);
			ps.setString(2, myPassword);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				RequestDispatcher rd = request.getRequestDispatcher("/Index.jsp");
				rd.include(request, response);
			} else {

				out.print("<h3 style='color:red'> UserId and Password didnt matched</h3>");

				RequestDispatcher rd = request.getRequestDispatcher("/loginIndex.html");
				rd.include(request, response);
			}
		} catch (Exception e) {
			e.printStackTrace();

			out.print("<h3 style='color:red'>" + e.getMessage() + "</h3>");

			RequestDispatcher rd = request.getRequestDispatcher("/loginIndex.html");
			rd.include(request, response);
		}

	}

}
