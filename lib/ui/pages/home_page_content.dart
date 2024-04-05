import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/milk_database.dart';
import '../../data/milk_model.dart';
import 'milk_details_page.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  MilkDatabase milkDatabase = MilkDatabase.instance;
  int currentPageIndex = 0;
  List<MilkModel> milks = [];

  @override
  void initState() {
    refreshMilks();
    super.initState();
  }

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
    return Center(
      child: milks.isEmpty
          ? const Text('No Data yet')
          : Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 30),
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
                        Visibility(
                            visible: entry.quantity != null ? true : false,
                            child: Text(
                                ' | ${entry.quantity.toString()} ml')),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
