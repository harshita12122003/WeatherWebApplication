<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Weather Application</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/Style.css">
<script>
function addCity(city) {
	fetch('AddCities', {
        method: 'POST',
        headers: {
        	'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'city=' + encodeURIComponent(city)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok ' + response.statusText);
        }
        return response.json();
    })
    .then(data => {
        console.log("here", data);
        alert("City Successfully Added");
    })
    .catch(error => alert('City Already e', error));
}
function formatDate(timestamp) {
    const date = new Date(timestamp * 1000); // Convert to milliseconds
    const options = {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    };
    return date.toLocaleDateString('en-US', options);
}
function getWeatherData(city) {
	console.log("city recieved", city);
	fetch('WeatherFetchServlet', {
        method: 'POST',
        headers: {
        	'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'city=' + encodeURIComponent(city)
    })
    .then(response => {
    	console.log("response: ",response);
    	if (!response.ok) {
            throw new Error('Network response was not ok ' + response.statusText);
        }
        return response.json();
    })
    .then(data => {
    	console.log("weatherData: ", data);
    	displayWeatherData(data)
    })
    .catch(error => console.error('Error fetching data:', error));
}
function getLatLongWeatherData(latitude, longitude) {
    console.log("Latitude and Longitude received", latitude, longitude);
    fetch('LonLatServlet?Latitude=' + encodeURIComponent(latitude) + '&Longitude=' + encodeURIComponent(longitude), {
        method: 'GET'
        
    })
    .then(response => {
        console.log("response: ", response);
        if (!response.ok) {
            throw new Error('Network response was not ok ' + response.statusText);
        }
        return response.json();
    })
    .then(data => {
        console.log("LatLongWeatherData: ", data);
        displayWeatherData(data);
    })
    .catch(error => console.error('Error fetching data:', error));
}

function displayWeatherData(data) {
	const dateElement = document.getElementById("date")
	const cityElement = document.getElementById("city")
	const temperatureElement = document.getElementById("temperature")
	const weatherConditionElement = document.getElementById("weatherCondition")
	const humidityElement = document.getElementById("humidity")
	const windSpeedElement = document.getElementById("windSpeed")
	const weatherIcon = document.getElementById("weather-icon");
	
	dateElement.innerText = formatDate(data.dt);
	cityElement.innerText = data.name;
	temperatureElement.innerText = (data.main.temp - 273.15).toFixed(2) + "°C";
	weatherConditionElement.value = data.weather[0].main;
	humidityElement.innerText = data.main.humidity + "%";
	windSpeedElement.innerText = data.wind.speed + "km/h";
	
	 console.log("Weather Condition:", data.weather[0].main);
	  switch (data.weather[0].main) {
      case 'Clouds':
          weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiwFTkt5z_dxU6w1UnS1PxiZV3HDiPGsAW5Lrsp09MnlCmkQre9GzO8MnGytaaY1eZoqBN6SMJ4U578_uDtiuXswovr1T3o-Kt5KK0mlN_zC0RDodJFaKHQ3Uk-HIZ3vuMvAKNJi8DDFwWA7F6BOxz78Oh-UePwJTuc3PG0ZIZypPE1xlMPl5z46joaEw/s320/Clouds.png";
          break;
      case 'Clear':
          weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj7pmzNCftryAfpa1YBSzVeYtjgxDQnw09Ug0HVV47J8GEtHPYTH9hJgZ2M1k0YgE0pcZ1qekr4C14zyPCiVuQAfXLClK8Ww3hYB6v77yElP7Lo5BnUKo4n-w6yB17FAbw51WST6YKS0GMwyA4fYNxOZxEyNL6HhUfFRgVhOW0GyRdBRriMHFQ-qfh4cA/s320/sun.png";
          break;
      case 'Rain':
          weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgDW_NdwvxV796rkFf43qmUDiTQePn5dg7PDfn1SijfpjtB0AWJMBcifU6LWyW7iOtjZhfqIJnKEGQ1PwbbXS7NoKMSAmvy7i2ljWXMYLue3EBIBBR2qTFbs6QCe5eoFr2CU9WzCVJ8u0J3z3eAo3Ajv1LXamZASFtbj9sA_gD-Kp3hfgAk17Xh17RoLQ/s320/rainy.png";
          break;
      case 'Mist':
          weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVpL23l0t1U_ibWi01TFcHMF6J_t-9Ada5PavGlwG4M_mKIcx0pV1md9SN9ip1d84NaVowml5Do16XO3nsuttnM2-Ov05d-wCjEYjdzaOYfKvijw8k6Hfj9pOiPyEZTp2W20EPbTeONTgJE2Rdxs4KZUfg6f2PmbMF1094NcqJ7DwSFUQwYiRmVCNvuA/s320/mist.png";
          break;
      case 'Snow':
          weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj-P3iT_uQK95qFY4h7QGdEtbRc1aVQo9BZy0ZWyPBvCNrP-4wnRStw0xYj9e4xa4ZlYISeNZqVJ33UP4YukR4jBennDD_obIN4QxYNZHdzG_z6_MNL2U08wMXwdFhtfvitW5LGiHgrwMJFC8QJFqbSO3woGSBqOdagGxaEQ20_S31Gc-GYL4vYzPzaPw/s320/snow.png";
          break;
      case 'Haze':
          weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjld66Ia5g_hpBn3Impi3zzOBHqWkjQInGLxTb2uXksuCsrkQU8HjlVyLobEJEGg8fRSIxeFzldGEHUmWcaiZBwAcRy4dGDpFX1BjTSB56qmBjW5tEW3RSC9_mCuLU_a8RuXchxGY7Oc8HLLl-IfaDW19Z0ZJJfNae9tECXRIyEu7rmJ3da08z8cI-phw/s320/haze.png";
          break;
      case 'Drizzle':
          weatherIcon.src = "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgDW_NdwvxV796rkFf43qmUDiTQePn5dg7PDfn1SijfpjtB0AWJMBcifU6LWyW7iOtjZhfqIJnKEGQ1PwbbXS7NoKMSAmvy7i2ljWXMYLue3EBIBBR2qTFbs6QCe5eoFr2CU9WzCVJ8u0J3z3eAo3Ajv1LXamZASFtbj9sA_gD-Kp3hfgAk17Xh17RoLQ/s320/rainy.png";
    	  break;
      default:
          weatherIcon.src = "";
          break;
  }
}
function onSearch() {
    const city = document.getElementById('searchInput').value;
    if (citiesData.includes(city)) {
        getWeatherData(city);
    } else {
        if (confirm("City not found. Do you want to add it?")) {
            addCity(city);
        }
    }
}

function onAddCityClicked() {
	const city = document.getElementById('inputCity').value;
	addCity(city)
}

function onClickSubmit() {
    const city = document.getElementById('inputCity').value;
    getWeatherData(city);
}
function onClickSubmitLatLon() {
    const latitude = document.getElementById('inputLatitude').value;
    const longitude = document.getElementById('inputLongitude').value;
    getLatLongWeatherData(latitude, longitude);
}


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
            const citiesCard = document.getElementById('citiesCard');
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
        .catch(error => alert('Error fetching cities:', error));
});
</script>

</head>
<body>
	<div class="left-sidebar">
		<h2>Average Temperature</h2>
		<form action="AvgTempServlet" method="post">
			Start Date: <input type="date" name="startDate" required> End
			Date: <input type="date" name="endDate" required>
			<button id="SearchButton" class="side-button-style">Get
				Average Temperature</button>
		</form>
	</div>
	<div class="content">
		<div class="city-search-container">
			<input id="inputCity" name="city" type="text"
				placeholder="Enter City Name" />
			<button id="SearchButton" onClick="onClickSubmit()"
				class="button-style">Submit</button>
			<button class="button-style" onClick="onAddCityClicked()">
				<span class="plus-icon">+</span>
			</button>
		</div>
		<div class="longLat-search-container">
			<input id="inputLongitude" name="Longitude" type="text"
				placeholder="Enter Longitude" /> <input id="inputLatitude"
				name="Latitude" type="text" placeholder="Enter Latitude" />
			<button id="SearchButton" onClick="onClickSubmitLatLon()"
				class="button-style">Submit</button>
		</div>
		<div class="weatherDetails">
			<div class="weatherIcons">
				<img src="" alt="clouds" id="weather-icon"> <input
					type="hidden" id="weatherCondition" value="${weatherCondition}"></input>
			</div>
			<div class="cityDetails">
				<div class="desc" id="city">
					<strong></strong>
				</div>
				<div class="date" id="date"></div>
			</div>
			<div class="windDetails">
				<div class="humidityBox">
					<img
						src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhgr7XehXJkOPXbZr8xL42sZEFYlS-1fQcvUMsS2HrrV8pcj3GDFaYmYmeb3vXfMrjGXpViEDVfvLcqI7pJ03pKb_9ldQm-Cj9SlGW2Op8rxArgIhlD6oSLGQQKH9IqH1urPpQ4EAMCs3KOwbzLu57FDKv01PioBJBdR6pqlaxZTJr3HwxOUlFhC9EFyw/s320/thermometer.png"
						alt="Humidity">
					<div class="humidity">
						<span>Humidity </span>
						<h2 id="humidity"></h2>

					</div>
				</div>
				<div class="temperature">
					<img
						src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhgr7XehXJkOPXbZr8xL42sZEFYlS-1fQcvUMsS2HrrV8pcj3GDFaYmYmeb3vXfMrjGXpViEDVfvLcqI7pJ03pKb_9ldQm-Cj9SlGW2Op8rxArgIhlD6oSLGQQKH9IqH1urPpQ4EAMCs3KOwbzLu57FDKv01PioBJBdR6pqlaxZTJr3HwxOUlFhC9EFyw/s320/thermometer.png"
						alt="Temperature">
					<div class="temperature">
						<span>Temperature</span>
						<h2 id="temperature"></h2>

					</div>
				</div>
				<div class="windSpeed">
					<img
						src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiyaIguDPkbBMnUDQkGp3wLRj_kvd_GIQ4RHQar7a32mUGtwg3wHLIe0ejKqryX8dnJu-gqU6CBnDo47O7BlzCMCwRbB7u0Pj0CbtGwtyhd8Y8cgEMaSuZKrw5-62etXwo7UoY509umLmndsRmEqqO0FKocqTqjzHvJFC2AEEYjUax9tc1JMWxIWAQR4g/s320/wind.png">
					<div class="wind">
						<span>Wind Speed</span>
						<h2 id="windSpeed"></h2>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="right-sidebar">
		<h2>Saved Cities</h2>
		<div id="cardContainer">
			<c:if test="${not empty errorMessage}">
				<div style="color: red;">${errorMessage}</div>
			</c:if>
			<div id="citiesCard"></div>
		</div>
	</div>
</body>
</html>