import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocean24/services/news_api.dart';

// The state of our StateNotifier should be immutable.
// We could also use packages like Freezed to help with the implementation.
@immutable
class NewsState {
  final List newsData;
  final bool isLoading;

  const NewsState({required this.newsData, this.isLoading = true});

  NewsState copyWith({bool? isLoading, List? newsData, List? newsSearchData}) {
    return NewsState(
        newsData: newsData ?? this.newsData,
        isLoading: isLoading ?? this.isLoading);
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier() : super(const NewsState(newsData: [])) {
    loadNews();
  }

  loadNews() async {
    state = const NewsState(isLoading: true, newsData: []);
    final newsResponse = await NewsApi().getHeadlines();
    state = NewsState(newsData: newsResponse, isLoading: false);
  }

  loadSearchedNews(Map<String, dynamic> filters) async {
    state = const NewsState(newsData: [], isLoading: true);
    final newsResponse = await NewsApi().searchNews(filters);
    state = NewsState(newsData: newsResponse, isLoading: false);
  }
}

final newsProvider =
    StateNotifierProvider<NewsNotifier, NewsState>((ref) => NewsNotifier());
