import 'package:baby_tracker/data/milk_database.dart';
import 'package:baby_tracker/ui/home_page_content.dart';
import 'package:baby_tracker/ui/milk_details_page.dart';
import 'package:baby_tracker/ui/search_page.dart';
import 'package:flutter/material.dart';
import '../data/milk_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MilkDatabase milkDatabase = MilkDatabase.instance;
  int currentPageIndex = 0;
  List<MilkModel> milks = [];

  refreshMilks() {
    milkDatabase.readAll().then((value) {
      setState(() {
        milks = value;
      });
    });
  }

  goToMilkDetailsPage({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MilkDetailsPage(milkId: id)),
    );
    refreshMilks();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.white,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.search),
              icon: Icon(Icons.search_outlined),
              label: 'Search',
            ),
          ],
        ),
        body: <Widget>[
          /// Home page
          const HomePageContent(),

          /// Search page
          const SearchPage(),
        ][currentPageIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: goToMilkDetailsPage,
          tooltip: 'Create',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
