import 'package:flutter/material.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/presentation/features/endows/endow.dart';
import 'package:hosco/presentation/features/endows/views/endow_layout.dart';

class HomeEndow extends StatefulWidget {
  final Function changeView;
  HomeEndow({Key key, this.changeView}) : super(key: key);

  @override
  _HomeEndowState createState() => _HomeEndowState();
}

class _HomeEndowState extends State<HomeEndow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(
          'Ưu đãi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xfff4f6f9),
      body: Container(color: Colors.grey[200],child: AllEndow()),
      
    );
  }
}
