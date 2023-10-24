import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocean24/services/news_api.dart';

// The state of our StateNotifier should be immutable.
// We could also use packages like Freezed to help with the implementation.
@immutable
class NewsState {
  final List newsData;
  final List newsSearchData;
  final bool isLoading;

  const NewsState(
      {required this.newsData,
      required this.newsSearchData,
      this.isLoading = true});

  NewsState copyWith({bool? isLoading, List? newsData, List? newsSearchData}) {
    return NewsState(
        newsData: newsData ?? this.newsData,
        newsSearchData: newsSearchData ?? this.newsSearchData,
        isLoading: isLoading ?? this.isLoading);
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier() : super(const NewsState(newsData: [], newsSearchData: [])) {
    loadNews();
  }

  loadNews() async {
    state = const NewsState(isLoading: true, newsData: [], newsSearchData: []);
    final newsResponse = await NewsApi().getHeadlines();
    state = NewsState(
        newsData: newsResponse, newsSearchData: const [], isLoading: false);
  }

  loadSearchedNews(Map<String, dynamic> filters) async {
    state = const NewsState(newsData: [], newsSearchData: [], isLoading: true);
    final newsResponse = await NewsApi().searchNews(filters);
    final headlines = await NewsApi().getHeadlines();
    state = NewsState(
        newsData: headlines, newsSearchData: newsResponse, isLoading: false);
  }
}

final newsProvider =
    StateNotifierProvider<NewsNotifier, NewsState>((ref) => NewsNotifier());
