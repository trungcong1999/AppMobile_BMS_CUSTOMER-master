import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/presentation/features/endows/endow.dart';
import 'package:hosco/presentation/features/endows/endow_bloc.dart';
import 'package:hosco/presentation/features/endows/views/endow_home.dart';
import 'package:hosco/presentation/features/profile/profile.dart';
import 'package:hosco/presentation/features/wrapper.dart';
import 'package:hosco/presentation/widgets/independent/scaffold.dart';

class EndowsScreen extends StatefulWidget {
  EndowsScreen({Key key}) : super(key: key);

  @override
  _EndowsScreenState createState() => _EndowsScreenState();
}

class _EndowsScreenState extends State<EndowsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: OpenFlutterScaffold(
        body: EndowWrapper(),
        bottomMenuIndex: 2,
      ),
    );
  }
}

class EndowWrapper extends StatefulWidget {
  @override
  _EndowWrapperState createState() => _EndowWrapperState();
}

class _EndowWrapperState extends OpenFlutterWrapperState<EndowWrapper> {
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
