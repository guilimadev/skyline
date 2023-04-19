// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:skyline/pages/hourly_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

import 'pages/weekly_screen.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(11, 36, 71, 100),
            background: const Color.fromRGBO(11, 36, 71, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var city = '';
  var lat = '';
  var long = '';
  final textController = TextEditingController();
  final controller = PageController(keepPage: true);
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future getLocation(String city) async {
    var apikey = 'f47d0c7f86f35258f275abc8fa10f6d5';
    var url =
        'http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=$apikey';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var apiData = convert.jsonDecode(response.body);

      setState(() {
        city = apiData[0]['name'].toString();
        lat = apiData[0]['lat'].toString();
        long = apiData[0]['lon'].toString();
      });
    }
    print(lat);
  }

  @override
  void initState() {
    textController.text = '';
    super.initState();

    initialization();
  }

  void initialization() async {
    const Center(
      child: Text('Logo', style: TextStyle(color: Colors.black, fontSize: 30)),
    );
    await Future.delayed(const Duration(seconds: 3));

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    // final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Center(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: textController,
                              onChanged: (text) {
                                getLocation(text);
                                setState(() {
                                  city = text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search location',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SmoothPageIndicator(
              controller: controller,
              count: 2,
              effect: ExpandingDotsEffect(
                  dotHeight: 1, expansionFactor: 2, dotColor: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: PageView(
                controller: controller,
                children: [
                  HourlyScreen(
                    city: city,
                    lat: lat,
                    long: long,
                  ),
                  WeeklyScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
