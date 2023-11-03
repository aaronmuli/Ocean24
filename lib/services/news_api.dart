import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ocean24/models/news_data.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsApi {
  String baseURL = "newsapi.org";
  String apiKey = "e932dfd2a8c0407f8f218c1ae2af5f91";

  bool isFetching = false;
  String errorMessage = "";

// search queries
// search endpoint = /v2/everything

// search query - q="query"
// search in - searchIn=[title, content, description]
// from - from="date e.g 2023-09-18"
// to - to="date e.g 2023-09-13"
// sortBy - sortBy=[relevancy, popularity, publishedAt]
// language - language=[a 2 letter ISO-639-1 code e.g en, es, fr e.t.c]
// sources - sources=[]

// top headlines
// top headlines endpoint = /v2/top-headlines
// category - category=[business, entertainment,general,health,science,sports,technology]

// fetch the top headlines
  getHeadlines() async {
    try {
      String category = "";
      List<Map<String, dynamic>> topHeadlines = [];
      Uri headlinesURL;

      if (category == "") {
        headlinesURL = Uri.https(baseURL, "/v2/top-headlines",
            {"category": "general", "language": "en", "apiKey": apiKey});
      } else {
        headlinesURL = Uri.https(baseURL, "/v2/top-headlines",
            {"category": category, "language": "en", "apiKey": apiKey});
      }

      dynamic response = await http.get(headlinesURL);

      if (response.statusCode == 200) {
        var jsonRes = jsonDecode(response.body);

        for (var article in jsonRes["articles"]) {
          NewsData newsdata = NewsData(article);

          if (newsdata.title != "[Removed]") {
            topHeadlines.add({
              "title": newsdata.title,
              "author": newsdata.author,
              "content": newsdata.content,
              "pageURL": newsdata.pageURL,
              "imageURL": newsdata.imageURL,
              "publishedAt": newsdata.publishedAt,
              "sourceID": newsdata.sourceID,
              "sourceName": newsdata.sourceName
            });
          }
        }

        return topHeadlines;
      } else {
        errorMessage = "something went wrong, please try again";
        return [];
      }
    } catch (e) {
      errorMessage =
          "something went wrong, please check your internet connection";
      return [];
    }
  }

// search for news applying filters
  searchNews(Map<String, dynamic> filters) async {
    try {
      List<Map<String, dynamic>> searchResults = [];
      Uri searchURL;
      dynamic response;

      if (filters.isNotEmpty) {
        // defaults
        Map<String, dynamic> queries = {"language": "en", "apiKey": apiKey};

        // adding user filters to defaults
        queries.addEntries(filters.entries);

        // url setup
        searchURL = Uri.https(baseURL, "/v2/everything", queries);

        response = await http.get(searchURL);
      } else {
        isFetching = false;
        errorMessage = "can't search, make sure search phrase is not empty";
      }

      if (response.statusCode == 200) {
        var jsonRes = jsonDecode(response.body);
        for (var article in jsonRes["articles"]) {
          NewsData newsdata = NewsData(article);

          searchResults.add({
            "title": newsdata.title,
            "author": newsdata.author,
            "content": newsdata.content,
            "pageURL": newsdata.pageURL,
            "imageURL": newsdata.imageURL,
            "publishedAt": newsdata.publishedAt,
            "sourceID": newsdata.sourceID,
            "sourceName": newsdata.sourceName
          });
        }

        return searchResults;
      } else {
        isFetching = false;
        errorMessage = 'something went wrong, please try again later';

        return [];
      }
    } catch (e) {
      isFetching = false;
      errorMessage = e.toString();

      return [];
    }
  }
}
