import 'package:flutter/material.dart';
import 'package:weather_app/constant.dart';

import '../service/weather.dart';
import 'city_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.locationWeather}) : super(key: key);
  final locationWeather;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel weather = WeatherModel();
  int? temperature;
  String? weatherIcon;
  String? cityName;
  String? weatherMessage;
  int? temperatureMax;
  int? temperatureMin;
  // int? feelLike;

  @override
  void initState() {
    super.initState();
    updateUi(widget.locationWeather);
  }

  void updateUi(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        temperatureMax = 0;
        temperatureMin = 0;
        // feelLike = 0;
        return;
      }
      double temp = weatherData['main']['temp'];
      double tempMax = weatherData['main']['temp_max'];
      double tempMin = weatherData['main']['temp_min'];
      // double feels = weatherData['main']['feels_like'];
      temperature = temp.toInt();
      temperatureMax = tempMax.toInt();
      temperatureMin = tempMin.toInt();
      // feelLike = feels.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature!);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Weather Wise'),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: const AssetImage(
                'assets/location_background.jpg',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            )),
            constraints: const BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          var weatherData = await weather.getLocationWeather();
                          updateUi(weatherData);
                        },
                        child: const Icon(
                          Icons.near_me,
                          size: 50,
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          // var typeName = await Get.to(() => CityPage);
                          var typeName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CityPage();
                              },
                            ),
                          );
                          if (typeName != null) {
                            var weatherData =
                                await weather.getCityWeather(typeName);
                            updateUi(weatherData);
                          }
                        },
                        child: const Icon(
                          Icons.location_city,
                          size: 50,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Text(
                        '$temperature°C',
                        style: kTempTextStyle,
                      ),
                      Text(
                        weatherIcon!,
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Highest $temperatureMax°C',
                      style: const TextStyle(
                        fontFamily: 'Spartan MB',
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Lowest $temperatureMin°C',
                      style: const TextStyle(
                        fontFamily: 'Spartan MB',
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    // Text(
                    //   'Feels Like $feelLike°C',
                    //   style: const TextStyle(
                    //     fontFamily: 'Spartan MB',
                    //     fontSize: 30.0,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '$weatherMessage in $cityName',
                    // textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
