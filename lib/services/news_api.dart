import 'dart:convert';

import 'package:http/http.dart' as http;

String baseURL = "newsapi.org";
String apiKey = "e932dfd2a8c0407f8f218c1ae2af5f91";

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
void getHeadlines(String category) async {
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
    print(jsonRes);
  } else {
    print("something went wrong, please try again later");
  }
}

// search for news applying filters
void search(Map<String, dynamic> filters) async {
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
    print("can't search, search query is empty");
  }

  if (response.statusCode == 200) {
    var jsonRes = jsonDecode(response.body);
    print(jsonRes);
  } else {
    print("something went wrong, please try again later");
  }
}
