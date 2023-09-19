import 'package:flutter/material.dart';
import 'package:ocean24/services/news_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHeadlines("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              search({"q": "iphone 15"});
            },
            child: Text("search")),
      ),
    );
  }
}
