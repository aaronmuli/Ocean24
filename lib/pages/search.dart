import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocean24/providers/api_provider.dart';
import 'package:ocean24/components/news_card.dart';

class Search extends ConsumerWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Debouncer _debouncer = Debouncer();
    List news = ref.watch(newsProvider).newsSearchData;
    bool isLoading = ref.watch(newsProvider).isLoading;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: const Color(0xff1D1617).withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0)
          ]),
          child: TextField(
            onChanged: (value) {
              _debouncer.run(() {
                if (value.isNotEmpty) {
                  ref
                      .read(newsProvider.notifier)
                      .loadSearchedNews({'q': value});
                }
              });
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                hintText: 'Search News',
                hintStyle:
                    const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none)),
          ),
        ),
        isLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: news.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime dateTime =
                        DateTime.parse(news[index]["publishedAt"]);

                    String time =
                        TimeOfDay.fromDateTime(dateTime).format(context);
                    String date =
                        "${dateTime.year}/${dateTime.month}/${dateTime.day}";

                    return NewsCard(
                      imageURL: news[index]["imageURL"],
                      time: time,
                      date: date,
                      title: news[index]["title"],
                      sourceName: news[index]["sourceName"],
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class Debouncer {
  final int milliseconds;

  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
