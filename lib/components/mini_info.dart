// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class MiniInfo extends StatelessWidget {
  const MiniInfo(
      {super.key,
      required this.hour,
      required this.temp,
      required this.iconURL});

  final String hour;
  final int temp;
  final String iconURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      width: MediaQuery.sizeOf(context).width * 0.25,
      height: MediaQuery.sizeOf(context).height * 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            hour.substring(11, 16),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Image.network(
            'http://openweathermap.org/img/w/$iconURL.png',
          ),
          Text('$tempºC',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
