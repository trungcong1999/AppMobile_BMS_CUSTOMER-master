import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreferentialScreen extends StatefulWidget {
  @override
  _PreferentialScreenState createState() => _PreferentialScreenState();
}

class _PreferentialScreenState extends State<PreferentialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('preferential'),
      ),
    );
  }
}
