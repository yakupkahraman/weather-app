import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('YOUR API KEY');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    List<double> _positions = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather =
          await _weatherService.getWeather(_positions[0], _positions[1]);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/clear.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'dust':
        return 'assets/cloud.json';
      case 'smoke':
      case 'mist':
      case 'haze':
      case 'fog':
        return 'assets/foggy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/clear.json';
      case 'snow':
        return 'assets/snow.json';
      default:
        return 'assets/clear.json';
    }
  }

  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(
                  Icons.location_on,
                  size: 30,
                  color: Colors.grey[700],
                ),
                Text(
                  _weather?.cityName ?? "loading city...",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            Lottie.asset(getWeeatherAnimation(_weather?.mainCondition)),
            Text(
              '${_weather?.temperature.round()}°C',
              style: Theme.of(context).textTheme.displayLarge,
            )
          ],
        ),
      ),
    );
  }
}
