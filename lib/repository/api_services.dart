import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../service/location.dart';

class ApiProvider extends GetConnect {
  String url = 'https://api.openweathermap.org/data/2.5';
  String appId = '1c8806a8edbec6e1c42773c8e3213798';
  Future getData() async {
    Location location = Location();
    await location.determinePosition();
    http.Response response = await http.get(Uri.parse(
        '$url/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$appId&units=metric'));
    if (response.statusCode == 200) {
      print(response.body);
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> getCityWeather(String cityName) async {
    http.Response response = await http
        .get(Uri.parse('$url/weather?q=$cityName&appid=$appId&units=metric'));
    if (response.statusCode == 200) {
      print(response.body);
      var weatherData = response.body;
      return jsonDecode(weatherData);
    } else {
      print(response.statusCode);
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
