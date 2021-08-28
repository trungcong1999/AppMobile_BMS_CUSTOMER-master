import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hosco/data/local/news/service_news.dart';
import 'package:hosco/data/model/article_news.dart';
import 'package:hosco/data/test/data.dart';
import 'package:hosco/presentation/features/news/views/foryoucontainer.dart';
import 'package:hosco/presentation/features/news/views/trending_container.dart';
import 'package:hosco/presentation/features/profile/profile.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';
import 'package:hosco/presentation/widgets/independent/scaffold.dart';

class NewsScreenMain extends StatefulWidget {
  NewsScreenMain({Key key}) : super(key: key);

  @override
  _NewsScreenMainState createState() => _NewsScreenMainState();
}

class _NewsScreenMainState extends State<NewsScreenMain> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: OpenFlutterScaffold(
        body: NewsScreen(),
        bottomMenuIndex: 2,
      ),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  ServiceNews client = ServiceNews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tin tức',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        
      ),
      backgroundColor: Color(0xfff4f6f9),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, bottom: 10, top: 10),
                      child: Text(
                        'Tin tức nổi bật',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 250,
                      padding: EdgeInsets.only(left: 10),
                      child: FutureBuilder(
                        future: client.getDataNews(2),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            List<ArticleNews> articles = snapshot.data;
                            return ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: articles == null
                                  ? 0
                                  : (articles.length > 10
                                      ? 10
                                      : articles.length),
                              itemBuilder: (context, index) =>
                                  TrendingContainer(articles[index], context),
                            );
                          } else {
                            return LoadingView();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        'Tin tức mới nhất',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    buildForYouContainers(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForYouContainers() {
    return FutureBuilder(
      future: client.getHomeNews(),
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
    );
  }
}
