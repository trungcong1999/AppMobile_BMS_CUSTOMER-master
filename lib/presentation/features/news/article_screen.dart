import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hosco/config/routes.dart';
import 'package:hosco/data/local/news/service_news.dart';
import 'package:hosco/data/model/article_news.dart';
import 'package:hosco/presentation/features/news/views/foryoucontainer.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';
import 'package:intl/intl.dart';

class ArticleScreen extends StatelessWidget {
  final ArticleNews article;
  const ArticleScreen({Key key, this.article}) : super(key: key);
  Widget buildForYouContainers() {
    ServiceNews client = ServiceNews();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Tin tức mới nhất',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: client.getDataNews(2),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  List<ArticleNews> articles = snapshot.data;
                  return ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return ForYouContainer(
                          article: articles[index],
                        );
                      });
                } else {
                  return LoadingView();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text(
            'Chi tiết tin tức',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, hoscoRoutes.home);
            },
            icon: Icon(Icons.home),
          ),
        ],
        ),
        body: Container(
          color: Colors.grey[300],
          child: Stack(
            children: [
              ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: (article.picture != null)
                                ? NetworkImage(article.picture)
                                : AssetImage('assets/placeholder.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            article.title ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.timelapse_outlined),
                              SizedBox(width: 5,),
                              Text(
                                DateFormat('dd-MM-yyyy').format(article.createdAt)
                                ,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            child: Html(
                              data: article.full,
                              defaultTextStyle: TextStyle(fontSize: 18,color: Colors.black),
                              onLinkTap: (url) {
                                // open url in a webview
                              },
                              ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  buildForYouContainers(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
