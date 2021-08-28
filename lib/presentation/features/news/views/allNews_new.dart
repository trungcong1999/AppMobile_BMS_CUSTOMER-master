import 'package:flutter/material.dart';
import 'package:hosco/presentation/features/endows/endow.dart';
import 'package:hosco/presentation/features/news/views/articele_all_container.dart';

class AllNewsViewScreen extends StatelessWidget {
  const AllNewsViewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(
          'Tin tức',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => EndowsScreen()));
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ArticleContainer(),
      ),
    );
  }
}
