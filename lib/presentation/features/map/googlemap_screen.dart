import 'package:flutter/material.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/presentation/features/map/home_map.dart';

class GoogleMapScreen extends StatelessWidget {
  const GoogleMapScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(
          'Chi nhánh',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, hoscoRoutes.home);
          },
        ),
        centerTitle: true,
      ),
      body: HomeMap(),
    );
  }
}
