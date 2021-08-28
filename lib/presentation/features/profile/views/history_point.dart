import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/config/theme.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/local/news/service_news.dart';
import 'package:hosco/data/model/history_point.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';
import 'package:hosco/presentation/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryPointView extends StatefulWidget {
  @override
  _HistoryPointViewState createState() => _HistoryPointViewState();
}

class _HistoryPointViewState extends State<HistoryPointView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch sử tích điểm',
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
        child: HomeHistoryPoint(),
      ),
    );
  }
}

class HomeHistoryPoint extends StatefulWidget {
  @override
  _HomeHistoryPointState createState() => _HomeHistoryPointState();
}

class _HomeHistoryPointState extends State<HomeHistoryPoint> {
  Future<List<dynamic>> getPointHistory() async {
    var customerID = Storage().account?.id;
    final String url =
        'http://api.phanmembanhang.com/api/SelOrder/GetPointHistory/' +
            customerID;
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)['data'];
      return body;
    } else {
      throw HttpRequestException();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPointHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var _theme = Theme.of(context);
    return FutureBuilder(
      future: getPointHistory(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          var point = snapshot.data;
          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: point.length,
            itemBuilder: (context, index) {
              final items = point[index];
              final f = DateFormat('dd-MM-yyyy');
              final time = f.format(DateTime.parse(items['CreatedAt']));
              return SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: height / 5.5,
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(15),
                        shadowColor: Color(0x802196F3),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RichText(
                                      text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: 'Tên khách hàng: ',
                                      style: _theme.textTheme.display1,
                                    ),
                                    TextSpan(
                                      text: items['CustomerName'] ?? '',
                                      style: _theme.textTheme.display1.copyWith(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ])),
                                  Text('$time',
                                      style: _theme.textTheme.display3
                                          .copyWith(color: AppColors.lightGray))
                                ],
                              ),
                              SizedBox(
                                height: AppSizes.sidePadding,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: 'Điểm: ',
                                        style: _theme.textTheme.display1
                                            .copyWith(
                                                color:
                                                    _theme.primaryColorLight),
                                      ),
                                      TextSpan(
                                        text:
                                            NumberFormat.currency(locale: 'vi',symbol: '')
                                                .format(items['Point']),
                                        style: _theme.textTheme.display1,
                                      ),
                                    ])),
                                  ]),
                              SizedBox(
                                height: AppSizes.sidePadding,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ghi chú: ',
                                    style: _theme.textTheme.display1.copyWith(
                                        color: _theme.primaryColorLight),
                                  ),
                                  Flexible(
                                    child: Text(
                                      items['Note'] ??
                                          '', //orderStatus.toString().split('.')[1],
                                      style: _theme.textTheme.display1
                                          .copyWith(color: AppColors.green),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: AppSizes.sidePadding,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return LoadingView();
        }
      },
    );
  }
}

String format(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
}
