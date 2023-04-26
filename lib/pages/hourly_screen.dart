// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_overrides, annotate_overrides

import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import '../components/mini_info.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HourlyScreen extends StatefulWidget {
  const HourlyScreen({super.key, required this.lat, required this.long});
  final String lat;
  final String long;

  @override
  State<HourlyScreen> createState() => _HourlyScreenState();
}

class _HourlyScreenState extends State<HourlyScreen>
    with AutomaticKeepAliveClientMixin<HourlyScreen> {
  int temperature = 0;
  int feelsLike = 0;
  int temp_min = 0;
  int temp_max = 0;
  int clouds = 0;
  String description = '';
  String icon_url = '';
  String country_code = '';
  String city = '';
  int date = 0;
  bool isReady = false;
  bool isLoading = false;
  double wind_speed = 0.0;
  DateTime now = DateTime.now().toLocal();
  List nextHours = [];

  Future getWeather(String latTemp, String longTemp) async {
    var apikey = 'f47d0c7f86f35258f275abc8fa10f6d5';
    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latTemp&lon=$longTemp&appid=$apikey&units=metric';

    var url2 =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latTemp&lon=$longTemp&cnt=3&appid=$apikey&units=metric';

    http.Response response = await http.get(Uri.parse(url));
    http.Response response2 = await http.get(Uri.parse(url2));

    if (response.statusCode == 200 && response2.statusCode == 200) {
      var apiData = convert.jsonDecode(response.body);
      var apiData2 = convert.jsonDecode(response2.body);

      setState(() {
        now = DateTime.now().toLocal();
        temperature = apiData['main']['temp'].round();
        feelsLike = apiData['main']['feels_like'].round();
        temp_min = apiData['main']['temp_min'].round();
        temp_max = apiData['main']['temp_max'].round();
        city = apiData['name'];
        clouds = apiData['clouds']['all'];
        description = apiData['weather'][0]['description'];
        icon_url = apiData["weather"][0]["icon"];
        date = apiData['dt'];
        wind_speed = apiData['wind']['speed'];
        country_code = apiData['sys']['country'];
        nextHours = apiData2['list'];

        isReady = true;
        isLoading = false;
      });
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      ' $city',
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
                        setState(() {
                          isLoading = true;
                          isReady = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Center(
                          child: Text('Get Weather'),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isReady)
                  Column(
                    children: [
                      Text(
                        '${now.hour}:${now.minute} - ${now.day.toString()}/${now.month.toString()}/${now.year.toString()}',
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
                          Image.network(
                            'http://openweathermap.org/img/w/$icon_url.png',
                          ),
                          Text(
                            ' $temperatureº',
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
                        description.toUpperCase(),
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
                              Icons.cloud,
                              size: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cloudiness'),
                                Text(
                                  '$clouds%',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              endIndent: 5,
                              indent: 5,
                            ),
                            Icon(
                              Icons.wind_power_outlined,
                              size: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Wind Speed'),
                                Text(
                                  '${wind_speed.toString()} m/s',
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
                              'Next Hours',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            Text('See more',
                                style: TextStyle(color: Colors.blue))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MiniInfo(
                            hour: nextHours[0]['dt_txt'],
                            temp: nextHours[0]['main']['temp'].round(),
                            iconURL: nextHours[0]['weather'][0]['icon'],
                          ),
                          MiniInfo(
                            hour: nextHours[1]['dt_txt'],
                            temp: nextHours[1]['main']['temp'].round(),
                            iconURL: nextHours[1]['weather'][0]['icon'],
                          ),
                          MiniInfo(
                            hour: nextHours[2]['dt_txt'],
                            temp: nextHours[2]['main']['temp'].round(),
                            iconURL: nextHours[2]['weather'][0]['icon'],
                          ),
                        ],
                      )
                    ],
                  ),
              ],
            ),
            if (!isReady & !isLoading)
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text(
                  'Type a location and click the Get Weather button',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.05),
                ),
              ),
            if (isLoading)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 200.0),
                  child: Center(
                    child: LoadingAnimationWidget.twoRotatingArc(
                        color: Colors.white,
                        size: MediaQuery.of(context).size.height * 0.1),
                  )),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
