import 'package:flutter/material.dart';
import 'package:ocean24/pages/home_page.dart';
import 'package:ocean24/pages/search.dart';
import 'package:ocean24/pages/settings.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int currentSelected = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = <Widget>[HomePage(), Search(), Settings()];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
          selectedIndex: currentSelected,
          onDestinationSelected: (int index) {
            setState(() {
              currentSelected = index;
            });
          },
          destinations: const <Widget>[
            NavigationDestination(
                icon: Icon(Icons.apps_outlined), label: "headlines"),
            NavigationDestination(icon: Icon(Icons.search), label: "search"),
            NavigationDestination(
                icon: Icon(Icons.settings), label: "settings"),
          ]),
      body: SafeArea(child: screens[currentSelected]),
    );
  }
}
