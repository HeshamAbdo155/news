import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/Models/News.dart';

class NewsApi {
  String country;
  String category;

  NewsApi({required this.category, required this.country});

  Future<News> fetchArticles() async {
    http.Response response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=$country&category=$category&apiKey=0200a463afec4015aff23b7d45d9e14a'));
    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load Api <-----> ${response.statusCode}');
    }
  }
}
