import 'package:flutter/material.dart';
import 'package:hosco/data/model/article_news.dart';
import 'package:hosco/presentation/features/news/article_screen.dart';
import 'package:intl/intl.dart';

Widget TrendingContainer(ArticleNews article,BuildContext context){
  return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ArticleScreen(
                  article: article,
                )));
      },
      child: Container(
        constraints: BoxConstraints(
                            maxWidth: 300
                          ),
        margin: const EdgeInsets.only(right: 10,left: 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (article.picture != null) ? NetworkImage(article.picture) : AssetImage('assets/placeholder.png'),
                      )),
                ),
                Container(
                  height: 80,
                  
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            DateFormat('dd-MM-yyyy').format(article.createdAt),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                         
                          child: Text(
                              article.short ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
}