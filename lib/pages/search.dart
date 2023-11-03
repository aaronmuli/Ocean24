import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocean24/providers/api_provider.dart';
// import 'package:ocean24/components/news_card.dart';

class Search extends ConsumerWidget {
  const Search({Key? key}) : super(key: key);

  Future popMenu(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Material(
            child: Center(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: const Column(
                  children: [
                    // search in - searchIn=[title, content, description]
                    // from - from="date e.g 2023-09-18"
                    // to - to="date e.g 2023-09-13"
                    // sortBy - sortBy=[relevancy, popularity, publishedAt]
                    // language - language=[a 2 letter ISO-639-1 code e.g en, es, fr e.t.c]
                    // sources - sources=[]

                    DropdownMenu(
                        label: Text("Search In"),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "title", label: "Title"),
                          DropdownMenuEntry(value: "content", label: "Content"),
                          DropdownMenuEntry(
                              value: "description", label: "Description"),
                        ]),
                    DropdownMenu(label: Text("Sort By"), dropdownMenuEntries: [
                      DropdownMenuEntry(value: "relevancy", label: "Relevancy"),
                      DropdownMenuEntry(
                          value: "popularity", label: "Popularity"),
                      DropdownMenuEntry(
                          value: "publishedAt", label: "Published At"),
                    ]),
                    DropdownMenu(label: Text("Language"), dropdownMenuEntries: [
                      DropdownMenuEntry(value: "en", label: "English"),
                      DropdownMenuEntry(value: "es", label: "Spanish"),
                      DropdownMenuEntry(value: "fr", label: "French"),
                    ]),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Debouncer _debouncer = Debouncer();
    // List news = ref.watch(newsProvider).newsData;
    // bool isLoading = ref.watch(newsProvider).isLoading;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: const Color(0xff1D1617).withOpacity(0.11),
                blurRadius: 30,
                spreadRadius: 0.0)
          ]),
          child: TextField(
            onChanged: (value) {
              _debouncer.run(() {
                if (value.isNotEmpty) {
                  ref
                      .read(newsProvider.notifier)
                      .loadSearchedNews({'q': value});
                } else if (value.isEmpty) {
                  ref.read(newsProvider.notifier).loadNews();
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
                suffixIcon: IconButton(
                    onPressed: () => popMenu(context),
                    color: Colors.grey,
                    icon: const Icon(Icons.settings_suggest_outlined)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none)),
          ),
        ),
        // isLoading
        //     ? Expanded(
        //         child: SizedBox(
        //           height: MediaQuery.of(context).size.height / 2,
        //           child: const Center(
        //             child: CircularProgressIndicator(),
        //           ),
        //         ),
        //       )
        //     : Expanded(
        //         child: ListView.builder(
        //           itemCount: news.length,
        //           shrinkWrap: true,
        //           itemBuilder: (BuildContext context, int index) {
        //             DateTime dateTime =
        //                 DateTime.parse(news[index]["publishedAt"]);

        //             String time =
        //                 TimeOfDay.fromDateTime(dateTime).format(context);
        //             String date =
        //                 "${dateTime.year}/${dateTime.month}/${dateTime.day}";

        //             return NewsCard(
        //               imageURL: news[index]["imageURL"],
        //               time: time,
        //               date: date,
        //               title: news[index]["title"],
        //               sourceName: news[index]["sourceName"],
        //             );
        //           },
        //         ),
        //       ),
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
