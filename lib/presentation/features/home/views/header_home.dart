import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/presentation/features/home/home.dart';
import 'package:hosco/presentation/features/news/news_screen.dart';
import 'package:hosco/presentation/features/supports/support_screen.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:url_launcher/url_launcher.dart';

class Moods extends StatefulWidget {
  @override
  _MoodsState createState() => _MoodsState();
}

class _MoodsState extends State<Moods> {
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Main1View()));
                            },
                            icon: Container(
                                child: Image(
                              image: AssetImage(
                                  'assets/images/checkout/cartbag.png'),
                              color: Colors.pink,
                            )),
                            alignment: Alignment.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Mua Hàng',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsScreen()));
                            },
                            icon: Container(
                                child: Image(
                              image:
                                  AssetImage('assets/images/checkout/news.png'),
                              color: Colors.yellow,
                            )),
                            alignment: Alignment.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Tin Tức',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _bottomSheet(context);
                            },
                            icon: Container(
                                child: Image(
                              image:
                                  AssetImage('assets/images/checkout/help.png'),
                              color: Colors.green,
                            )),
                            alignment: Alignment.centerLeft,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Hỗ Trợ',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _bottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return Wrap(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Divider(
                      height: 2.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.phone_callback_outlined,
                        color: Colors.green,
                      ),
                      title: Text(
                         Storage().account?.Company_Tel1 ??'',
                        // 'Call: 19006129',
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () async {
                        _callMe('${Storage().account?.Company_Tel1}');
                      },
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.phone_callback_outlined,
                        color: Colors.green,
                      ),
                      title: Text(
                         Storage().account?.Company_Tel2 ??'',
                        // 'Call: 19006129',
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () async {
                        _callMe('${Storage().account?.Company_Tel2}');
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _callMe(String mobile) async {
    // Android
    var uri = 'tel:+'+ mobile;
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'tel:' + mobile;
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}
