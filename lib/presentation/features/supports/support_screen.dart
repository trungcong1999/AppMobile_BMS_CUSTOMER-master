import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  final String _phone = '+84 962 850 734';

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: 'Call me',
        currentButton: FloatingActionButton(
          heroTag: 'phone',
          backgroundColor: Colors.redAccent,
          mini: true,
          onPressed: () async {
            _callMe();
          },
          child: Icon(Icons.add_call),
        )));
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: 'Call zalo',
        currentButton: FloatingActionButton(
            heroTag: 'directions',
            backgroundColor: Colors.transparent, //blueAccent,
            mini: true,
            onPressed: () {
              launch('https://zalo.me/84962850734');
            },
            child: Image.asset(
              'assets/icons/signin/zalo.png',
              width: 35.0,
            ))));
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        home: Scaffold(
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.only(bottom: 50.0),
          //   child: UnicornDialer(
          //       backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          //       parentButtonBackground: Colors.redAccent,
          //       orientation: UnicornOrientation.VERTICAL,
          //       parentButton: Icon(Icons.share_outlined),
          //       childButtons: childButtons),
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _callMe() async {
    // Android
    const uri = 'tel:+84 962 850 734';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'tel:84-962-850-734';
      print(uri);
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}
