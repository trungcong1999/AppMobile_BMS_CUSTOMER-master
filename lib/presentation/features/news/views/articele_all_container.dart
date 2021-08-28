import 'package:flutter/material.dart';
import 'package:hosco/data/local/news/service_news.dart';
import 'package:hosco/data/model/article_news.dart';
import 'package:hosco/presentation/features/news/article_screen.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';

class ArticleContainer extends StatelessWidget {
  const ArticleContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: WidgetLatestNews(),
          ),
        ],
      ),
    );
  }
}

class WidgetLatestNews extends StatefulWidget {
  @override
  _WidgetLatestNewsState createState() => _WidgetLatestNewsState();
}

class _WidgetLatestNewsState extends State<WidgetLatestNews> {
  ServiceNews client = ServiceNews();
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return FutureBuilder(
      future: client.getNewsList(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<ArticleNews> articles = snapshot.data;
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: articles.length,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              ArticleNews itemArticle = articles[index];
              if (index == 0) {
                return Stack(
                  children: <Widget>[
                    ClipRRect(
                      child: Image.network(
                        itemArticle.picture,
                        height: 192.0,
                        width: mediaQuery.size.width,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArticleScreen(
                                  article: itemArticle,
                                )));
                      },
                      child: Container(
                        width: mediaQuery.size.width,
                        height: 192.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                              0.0,
                              0.7,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 135.0,
                            right: 10.0,
                          ),
                          child: Text(
                            itemArticle.title.length > 25
                                ? itemArticle.title.substring(0, 65) + ' ...'
                                : itemArticle.title,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArticleScreen(
                                  article: itemArticle,
                                )));
                  },
                  child: Container(
                    width: mediaQuery.size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 72.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    itemArticle.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF325384),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  // Wrap(
                                  //   crossAxisAlignment: WrapCrossAlignment.center,
                                  //   children: <Widget>[
                                  //     Icon(
                                  //       Icons.launch,
                                  //       size: 12.0,
                                  //       color: Color(0xFF325384).withOpacity(0.5),
                                  //     ),
                                  //     SizedBox(width: 4.0),
                                  //     Text(
                                  //       itemArticle.source,
                                  //       style: TextStyle(
                                  //         color:
                                  //             Color(0xFF325384).withOpacity(0.5),
                                  //         fontSize: 12.0,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: ClipRRect(
                              child: Image.network(
                                itemArticle.picture ?? 'assets/placeholder.png',
                                width: 180.0,
                                height: 120.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return LoadingView();
        }
      },
    );
  }
}
