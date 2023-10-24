import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocean24/components/news_card.dart';
import 'package:ocean24/providers/api_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List news = ref.watch(newsProvider).newsData;
    bool isLoading = ref.watch(newsProvider).isLoading;

    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Top Headlines",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Get global news from different sources.",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        // ElevatedButton(
        //     onPressed: () {
        //       ref.read(newsProvider.notifier).loadNews();
        //     },
        //     child: Icon(Icons.refresh)),
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
      ]),
    );
  }
}
