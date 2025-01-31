// main.dart
import 'package:flutter/material.dart';

import '../Api_services/api_services.dart';
import '../Model/Weather_Model.dart';





class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService _weatherService = WeatherService();
  late Future<WeatherResponse> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService.fetchWeather('Dhaka');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: FutureBuilder<WeatherResponse>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data found', style: TextStyle(color: Colors.white)));
            }

            final weather = snapshot.data!;
            return Column(
              children: [
                // Location and Temperature Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Text(
                        '${weather.location.name}, ${weather.location.country}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${weather.current.tempC}°C',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        weather.current.condition.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Forecast Section
                Expanded(
                  child: ListView.builder(
                    itemCount: weather.forecast.forecastday.length,
                    itemBuilder: (context, index) {
                      final day = weather.forecast.forecastday[index];
                      return ListTile(
                        title: Text(
                          day.date,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Max: ${day.day.maxTempC}°C, Min: ${day.day.minTempC}°C',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Image.network('https:${day.day.condition.icon}'),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}