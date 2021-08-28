import 'package:flutter/material.dart';
import 'package:hosco/config/theme.dart';

class OpenFlutterSummaryLine extends StatelessWidget {
  final String title;
  final String summary;

  const OpenFlutterSummaryLine({Key key, this.title, this.summary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - AppSizes.sidePadding * 2;
    var _theme = Theme.of(context);
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.sidePadding, vertical: AppSizes.linePadding),
        child: Row(
          children: <Widget>[
            Container(
                width: width / 2,
                child: Text(title, style: _theme.textTheme.display3.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'Time New Roman'
                ))),
            Container(
                alignment: Alignment.centerRight,
                width: width / 2,
                child: Text(summary,
                    style: _theme.textTheme.display3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _theme.primaryColor))),
          ],
        ));
  }
}
