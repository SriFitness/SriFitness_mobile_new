import 'package:flutter/material.dart';

class MarketPlace extends StatefulWidget {
  const MarketPlace({super.key});

  @override
  State<MarketPlace> createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Market Place"),
      ),
    );
  }
}
