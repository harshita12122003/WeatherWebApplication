<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Weather Application</title>
<link rel="stylesheet" type="text/css" href="css/styles.css">
<script>
    let citiesData = []
    document.addEventListener("DOMContentLoaded", function() {
        fetch('AddCities')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                console.log("here", data);
                citiesData = data;
                const citiesCard = document.getElementById('cards-container');
                data.forEach(city => { 
                    const div = document.createElement('div');
                    div.className = 'city-card';
                    div.textContent = city;
                    div.addEventListener('click', function() {
                    	getWeatherData(city);
                    });
                    citiesCard.appendChild(div);
                });
            })
            .catch(error => console.error('Error fetching cities:', error));
    });
        
        function getWeatherData(city) {
        	console.log(city);
        	fetch('WeatherFetchServlet', {
                method: 'POST',
                headers: {
                	'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'city=' + encodeURIComponent(city)
            })
            .then(response => {
            	console.log("response",response);
            	if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
            	console.log("weatherData", data);
            	document.getElementById("temperatureHeading").innerText = data.main.temp + "°C";
            	displayWeatherData(data)
            })
            .catch(error => console.error('Error fetching data:', error));
        }
        
        function displayWeatherData(data) {
        	
        }
        
        function handleSubmit() {
            const city = document.getElementById('cityInput').value;
            getWeatherData(city);
        }
    </script>
</head>
<body>
	<h1>Weather Application</h1>
	<input type="text" name="city" placeholder="Enter city name"
		id="cityInput" required>
	<button type="submit" onClick="handleSubmit()">Submit</button>

	<div class="weatherDetails">

		<div class="weatherIcons">
			<img src="" alt="clouds" id="weather-icon">
			<H2 id="temperatureHeading">${temperature}°C</H2>
			<input type="hidden" id="wc" value="${weatherCondition}"></input>
		</div>
		<div class="cityDetails">
			<div class="desc">
				<strong>${city}</strong>
			</div>
			<div class="date">${date}</div>
		</div>
		<div class="windDetails">
			<div class="humidityBox">
				<img
					src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhgr7XehXJkOPXbZr8xL42sZEFYlS-1fQcvUMsS2HrrV8pcj3GDFaYmYmeb3vXfMrjGXpViEDVfvLcqI7pJ03pKb_9ldQm-Cj9SlGW2Op8rxArgIhlD6oSLGQQKH9IqH1urPpQ4EAMCs3KOwbzLu57FDKv01PioBJBdR6pqlaxZTJr3HwxOUlFhC9EFyw/s320/thermometer.png"
					alt="Humidity">
				<div class="humidity">
					<span>Humidity </span>
					<h2>${humidity}%</h2>
				</div>
			</div>
			<div class="windSpeed">
				<img
					src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiyaIguDPkbBMnUDQkGp3wLRj_kvd_GIQ4RHQar7a32mUGtwg3wHLIe0ejKqryX8dnJu-gqU6CBnDo47O7BlzCMCwRbB7u0Pj0CbtGwtyhd8Y8cgEMaSuZKrw5-62etXwo7UoY509umLmndsRmEqqO0FKocqTqjzHvJFC2AEEYjUax9tc1JMWxIWAQR4g/s320/wind.png">
				<div class="wind">
					<span>Wind Speed</span>
					<h2>${windSpeed}km/h</h2>
				</div>
			</div>
		</div>
	</div>

	<h3>City List</h3>
	<div id="cards-container">
		<!-- Dynamic city cards will be loaded here -->
	</div>

</body>
</html>
