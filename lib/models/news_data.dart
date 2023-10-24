class NewsData {
  String sourceName = "";
  String sourceID = "";
  String author = "";
  String pageURL = "";
  String imageURL = "";
  String content = "";
  String title = "";
  String publishedAt = "";

  NewsData(dynamic newsData) {
    sourceName = newsData["source"]["name"] ?? "unknown";
    sourceID = newsData["source"]["id"] ?? "uknown";
    author = newsData["author"] ?? "unknown";
    title = newsData["title"] ?? "No Title";
    imageURL = newsData["urlToImage"] ?? "null";
    publishedAt = newsData["publishedAt"] ?? "unknown";
    content = newsData["content"] ?? "Content Unavailable";
    pageURL = newsData["url"] ?? "Page not Available";
  }
}
