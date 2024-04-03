import 'package:baby_tracker/data/milk_database.dart';
import 'package:baby_tracker/ui/milk_details_page.dart';
import 'package:baby_tracker/ui/search_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    refreshMilks();
    super.initState();
  }

  // @override
  // void dispose() {
  //   milkDatabase.close();
  //   super.dispose();
  // }

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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
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
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Center(
          child: milks.isEmpty
              ? const Text('No Data yet')
              : Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: ListView.builder(
              itemCount: milks.length,
              itemBuilder: (context, index) {
                final entry = milks[index];
                return GestureDetector(
                  onTap: () => goToMilkDetailsPage(id: entry.id),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                                '${entry.type.substring(0, 1).toUpperCase() + entry.type.substring(1)} | ${DateFormat('dd-MM-yyyy').format(entry.takenDate)} | ${DateFormat.Hm().format(entry.takenDate)}'),
                            entry.quantity != null
                                ? Text(' | ${entry.quantity.toString()} ml')
                                : Container(),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        /// Search page
        const SearchPage(),
      ][currentPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: goToMilkDetailsPage,
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }
}
