import 'package:flutter/material.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/presentation/widgets/widgets.dart';

class EndowForMeView extends StatefulWidget {
  final Function changeView;

  const EndowForMeView({Key key, this.changeView}) : super(key: key);

  @override
  _EndowForMeViewState createState() => _EndowForMeViewState();
}

class _EndowForMeViewState extends State<EndowForMeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(
          'Ưu đãi của tôi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, hoscoRoutes.profile);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}