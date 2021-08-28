// To parse this JSON data, do
//
//     final articleNews = articleNewsFromJson(jsonString);

import 'dart:convert';

class ArticleNews {
    ArticleNews({
        this.id,
        this.title,
        this.short,
        this.full,
        this.picture,
        this.categoryId,
        this.isHot,
        this.isFeature,
        this.isHome,
        this.source,
        this.createdAt,
    });

    int id;
    String title;
    String short;
    String full;
    String picture;
    int categoryId;
    int isHot;
    int isFeature;
    int isHome;
    String source;
    DateTime createdAt;

    factory ArticleNews.fromJson(Map<String, dynamic> json) => ArticleNews(
        id: json['id'],
        title: json['title'],
        short: json['short'],
        full: json['full'],
        picture: json['picture'],
        categoryId: json['category_id'],
        isHot: json['is_hot'],
        isFeature: json['is_feature'],
        isHome: json['is_home'],
        source: json['source'],
        createdAt: DateTime.parse(json['created_at']),
    );


}
