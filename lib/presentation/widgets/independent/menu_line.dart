import 'package:flutter/material.dart';
import 'package:hosco/config/theme.dart';

class OpenFlutterMenuLine extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const OpenFlutterMenuLine(
      {Key key,
      @required this.title,
      @required this.subtitle,
      @required this.icon,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: AppColors.lightGray, fontWeight: FontWeight.bold),
        ),
        leading: Icon(icon,size: 30,color: Colors.red,),
        trailing: Icon(Icons.chevron_right),
      ),
      onTap: onTap,
    );
  }
}
