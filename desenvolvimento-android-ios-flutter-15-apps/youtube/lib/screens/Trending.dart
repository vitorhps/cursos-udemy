import 'package:flutter/material.dart';

class Trending extends StatefulWidget {
  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Em alta",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
