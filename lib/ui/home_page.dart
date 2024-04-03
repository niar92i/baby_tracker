import 'package:baby_tracker/data/milk_database.dart';
import 'package:baby_tracker/ui/milk_details_page.dart';
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

  List<MilkModel> milks = [];

  @override
  void initState() {
    refreshMilks();
    super.initState();
  }

  @override
  void dispose() {
    milkDatabase.close();
    super.dispose();
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
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
        // const Text('Data')
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToMilkDetailsPage,
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }
}
