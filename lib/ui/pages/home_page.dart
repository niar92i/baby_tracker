import 'package:baby_tracker/data/milk_database.dart';
import 'package:baby_tracker/ui/pages/home_page_content.dart';
import 'package:baby_tracker/ui/pages/milk_details_page.dart';
import 'package:baby_tracker/ui/pages/search_page.dart';
import 'package:flutter/material.dart';
import '../../data/milk_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _myPage = PageController(initialPage: 0);
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
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  iconSize: 30.0,
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    setState(() {
                      _myPage.jumpToPage(0);
                    });
                  },
                ),
                IconButton(
                  iconSize: 30.0,
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _myPage.jumpToPage(1);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _myPage,
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            HomePageContent(),
            SearchPage(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: goToMilkDetailsPage,
          tooltip: 'Create',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
