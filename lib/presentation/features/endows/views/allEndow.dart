import 'package:flutter/material.dart';
import 'package:hosco/data/local/news/service_news.dart';
import 'package:hosco/data/model/article_news.dart';
import 'package:hosco/presentation/features/news/article_screen.dart';
import 'package:hosco/presentation/features/news/views/allNews_new.dart';
import 'package:hosco/presentation/widgets/independent/loading_view.dart';
import 'package:intl/intl.dart';

class AllEndow extends StatefulWidget {
  final Function changeView;
  AllEndow({Key key, this.changeView}) : super(key: key);

  @override
  _AllEndowState createState() => _AllEndowState();
}

class _AllEndowState extends State<AllEndow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: WidgetLatestNews(),
          ),
          Expanded(flex: 1,child: Center())
          // InkWell(
          //   onTap: () {
          //     Navigator.push(context,
          //                   MaterialPageRoute(builder: (_) => AllNewsViewScreen()));
          //   },
          //   child: Container(
          //     height: 55,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         children: [
          //           Icon(
          //             Icons.star_rate_outlined,
          //             size: 25,
          //             color: Colors.red,
          //           ),
          //           SizedBox(
          //             width: 25,
          //           ),
          //           Text(
          //             'Tin mới',
          //             style: TextStyle().copyWith(
          //               color: Colors.black,
          //               fontSize: 16,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           Spacer(),
          //           Icon(
          //             Icons.chevron_right,
          //             size: 25,
          //             color: Colors.black,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),

          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // Container(
          //   height: 130,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(top: 5, left: 15),
          //         child: Text(
          //           'Danh mục ưu đãi',
          //           style: TextStyle(
          //               color: Colors.black,
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Column(
          //               children: [
          //                 InkWell(
          //                   child: Container(
          //                     width: 80,
          //                     child: Column(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         Container(
          //                           child: Image(
          //                             image: AssetImage(
          //                                 'assets/icons/favourites/gift-box.png'),
          //                             color: Colors.red,
          //                             height: 35,
          //                             width: 35,
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           height: 5,
          //                         ),
          //                         Text(
          //                           'Tất cả',
          //                           style: TextStyle(
          //                               color: Colors.black, fontSize: 14),
          //                           textAlign: TextAlign.center,
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             Column(
          //               children: [
          //                 InkWell(
          //                   child: Container(
          //                     width: 80,
          //                     child: Column(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         Container(
          //                           child: Image(
          //                             image: AssetImage(
          //                                 'assets/icons/favourites/megaphone.png'),
          //                             color: Colors.red,
          //                             height: 35,
          //                             width: 35,
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           height: 5,
          //                         ),
          //                         Text(
          //                           'Khuyến mãi',
          //                           style: TextStyle(
          //                               color: Colors.black, fontSize: 14),
          //                           textAlign: TextAlign.center,
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             Column(
          //               children: [
          //                 InkWell(
          //                   child: Container(
          //                     width: 80,
          //                     child: Column(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         Container(
          //                           child: Image(
          //                             image: AssetImage(
          //                                 'assets/icons/favourites/check-mark.png'),
          //                             color: Colors.red[800],
          //                             height: 35,
          //                             width: 35,
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           height: 5,
          //                         ),
          //                         Text(
          //                           'Chính sách bán hàng',
          //                           style: TextStyle(
          //                               color: Colors.black, fontSize: 14),
          //                           textAlign: TextAlign.center,
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             // Column(
          //             //   children: [
          //             //     InkWell(
          //             //       child: Container(
          //             //         width: 80,
          //             //         child: Column(
          //             //           mainAxisAlignment: MainAxisAlignment.center,
          //             //           children: [
          //             //             Container(
          //             //               child: Image(
          //             //                 image: AssetImage(
          //             //                     'assets/icons/favourites/label.png'),
          //             //                 color: Colors.red[800],
          //             //                 height: 35,
          //             //                 width: 35,
          //             //               ),
          //             //             ),
          //             //             SizedBox(
          //             //               height: 5,
          //             //             ),
          //             //             Text(
          //             //               'Voucher',
          //             //               style: TextStyle(
          //             //                   color: Colors.black, fontSize: 14),
          //             //               textAlign: TextAlign.center,
          //             //             ),
          //             //           ],
          //             //         ),
          //             //       ),
          //             //     ),
          //             //   ],
          //             // ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // Container(
          //   height: 100,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //   ),
          //   child: Center(
          //     child: Text('Chính sách ưu đãi không có sẵn'),
          //   ),
          // ),
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
      future: client.getDataNews(3),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<ArticleNews> articles = snapshot.data;
          return ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: articles.length,
            primary: true,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              ArticleNews itemArticle = articles[index];
              if (index == 0) {
                return Stack(
                  children: <Widget>[
                    ClipRRect(
                      child: itemArticle.picture != null
                          ? Image.network(
                              itemArticle.picture,
                              height: 192.0,
                              width: mediaQuery.size.width,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/placeholder.png',
                              height: 192.0,
                              width: mediaQuery.size.width,
                              fit: BoxFit.cover,
                            ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight:Radius.circular(15) )
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
                            top: 145.0,
                            right: 10.0,
                          ),
                          child: Text(
                            itemArticle.title.length > 45
                                ? itemArticle.title.substring(0, 50)
                                : itemArticle.title,
                            style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 80.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    itemArticle.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(height: 5,),
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.timelapse,
                                        size: 12.0,
                                        color: Color(0xFF325384).withOpacity(0.5),
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(itemArticle.createdAt)
                                        ,
                                        style: TextStyle(
                                          color:
                                              Color(0xFF325384).withOpacity(0.5),
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
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
                              child: itemArticle.picture != null
                          ? Image.network(
                              itemArticle.picture,
                              height: 120.0,
                              width: 180.0,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/placeholder.png',
                              height: 120.0,
                              width: 180.0,
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
