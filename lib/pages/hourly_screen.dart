// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import '../components/mini_info.dart';
import 'package:http/http.dart' as http;

class HourlyScreen extends StatefulWidget {
  const HourlyScreen(
      {super.key, required this.city, required this.lat, required this.long});
  final String lat;
  final String long;
  final String city;

  @override
  State<HourlyScreen> createState() => _HourlyScreenState();
}

class _HourlyScreenState extends State<HourlyScreen> {
  int temperature = 0;
  int feelsLike = 0;
  int temp_min = 0;
  int temp_max = 0;

  Future getWeather(String latTemp, String longTemp) async {
    var apikey = 'f47d0c7f86f35258f275abc8fa10f6d5';
    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latTemp&lon=$longTemp&appid=$apikey&units=metric';

    http.Response response = await http.get(Uri.parse(url));
    print('Entrei');
    if (response.statusCode == 200) {
      var apiData = convert.jsonDecode(response.body);

      setState(() {
        temperature = apiData['main']['temp'].round();
        feelsLike = apiData['main']['feels_like'].round();
        temp_min = apiData['main']['temp_min'].round();
        temp_max = apiData['main']['temp_max'].round();
      });
      print(apiData);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.room_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      ' ${widget.city}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        getWeather(widget.lat, widget.long);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Center(child: Text('Get Weather')),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Thu, Apr 13, 2023',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.white,
                      size: 60,
                    ),
                    Text(
                      ' $temperature',
                      style: TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Text(
                  '$temp_maxº/$temp_minº Feels like $feelsLikeº',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Calor do cão',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: MediaQuery.sizeOf(context).height * 0.07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        size: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Precipitation'),
                          Text(
                            '100%',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      VerticalDivider(
                        endIndent: 5,
                        indent: 5,
                      ),
                      Icon(
                        Icons.thunderstorm_outlined,
                        size: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('UV Index'),
                          Text(
                            'High',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next 3 Hours',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text('See more', style: TextStyle(color: Colors.blue))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MiniInfo(),
                    MiniInfo(),
                    MiniInfo(),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
