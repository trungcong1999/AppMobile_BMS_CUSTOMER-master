// Header of the block widget with title and description
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import 'package:flutter/material.dart';
import 'package:hosco/config/theme.dart';

class OpenFlutterBlockHeader extends StatelessWidget {
  final double width;
  final String title;
  final String linkText;
  final VoidCallback onLinkTap;
  final String description;

  const OpenFlutterBlockHeader(
      {Key key,
      @required this.width,
      @required this.title,
      this.linkText,
      this.onLinkTap,
      this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    const rightLinkWidth = 100.0;
    return InkWell(
      onTap: onLinkTap,
      child: Container(
        padding: EdgeInsets.only(
            top: AppSizes.sidePadding, left: AppSizes.sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: width - rightLinkWidth,
                  child: Text(title, style: TextStyle(fontSize: 22,color: Colors.red)),
                ),
                linkText != null
                    ? Container(
                        width: rightLinkWidth,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child:
                              Text(linkText, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.red[700])),
                        ),
                      )
                    : Container(),
              ],
            ),
            description != null
                ? Text(
                    description,
                    style: _theme.textTheme.body2,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
