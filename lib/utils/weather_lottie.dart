String getLottieAnimation(String weatherMain) {
  switch (weatherMain.toLowerCase()) {
    case 'clear':
      return 'assets/lottie/weather-sunny.json';
    case 'clouds':
      return 'assets/lottie/weather-partly cloudy.json';
    case 'rain':
    case 'drizzle':
      return 'assets/lottie/weather-partly shower.json';
    case 'thunderstorm':
      return 'assets/lottie/weather-thunder.json';
    case 'snow':
      return 'assets/lottie/weather-snow.json';
    case 'mist':
    case 'fog':
    case 'haze':
      return 'assets/lottie/weather-mist.json';
    case 'wind':
      return 'assets/lottie/weather-windy.json';
    default:
      return 'assets/lottie/weather-sunny.json'; // По умолчанию
  }
}
