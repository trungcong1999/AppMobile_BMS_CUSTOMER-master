import 'dart:convert';

import 'package:hosco/config/server_addresses.dart';
import 'package:hosco/config/storage.dart';
import 'package:hosco/data/error/exceptions.dart';
import 'package:hosco/data/model/article_news.dart';
import 'package:hosco/data/model/history_point.dart';
import 'package:hosco/data/model/purchase_order.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ServiceNews {
  //get data Hot News
  Future<List<ArticleNews>> getDataNews(int id) async {
    final String url = 'http://api.phanmembanhang.com/api/Crm/GetNewsListByCategory/$id';
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['data'];

      List<ArticleNews> articles =
          body.map((dynamic item) => ArticleNews.fromJson(item)).toList();
      return articles;
    } else {
      throw HttpRequestException();
    }
  }

  //get data feature news
  Future<List<ArticleNews>> getFeatureNews() async {
    var response = await http.get(
      ServerAddresses.getFeatureNews,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['data'];

      List<ArticleNews> articles =
          body.map((dynamic item) => ArticleNews.fromJson(item)).toList();
      return articles;
    } else {
      throw HttpRequestException();
    }
  }

  //get data list news
  Future<List<ArticleNews>> getNewsList() async {
    var response = await http.get(
      ServerAddresses.getNewsList,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['data'];

      List<ArticleNews> articles =
          body.map((dynamic item) => ArticleNews.fromJson(item)).toList();
      return articles;
    } else {
      throw HttpRequestException();
    }
  }

//get data list news
  Future<List<ArticleNews>> getHomeNews() async {
    var response = await http.get(
      ServerAddresses.getHomeNews,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Storage().token
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['data'];

      List<ArticleNews> articles =
          body.map((dynamic item) => ArticleNews.fromJson(item)).toList();
      return articles;
    } else {
      throw HttpRequestException();
    }
  }
  Future<List<PurchaseOrderList>> postPurchaseOrderData(int status,String date) async {
    final String url =
        'http://api.phanmembanhang.com/api/Customer/PurchaseOrderList';
        
    final msg = jsonEncode({
      'FilterType': -1,
      'FromDate': '$date',
      'ToDate': '$date',
      'LocationId': '',
      'OrderStatus': status,
      'SearchByOrderInfo': '',
      'SearchByCustomerInfo': '',
      'SearchByProductInfo': '',
      'PageSize': 10,
      'PageIndex': 0
    });
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + Storage().token
        },
        body: msg);
    // print('${response.statusCode}');
    if (response.statusCode == 200) {
      // var body = json.decode(response.body)['data'];
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['data'];
      List<PurchaseOrderList> purchase =
          body.map((dynamic item) => PurchaseOrderList.fromJson(item)).toList();
      return purchase;
    } else {
      //throw HttpRequestException();
      throw HttpRequestException();
    }
  }

  //get list history point
  
}
