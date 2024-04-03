import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../data/milk_database.dart';
import '../data/milk_model.dart';
import 'milk_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  MilkDatabase milkDatabase = MilkDatabase.instance;
  String _selectedDay = 'Tap to select a day';
  List<MilkModel> milks = [];
  DateTime? datePicked;
  DateTime? endDateTime;
  int quantityConsumed = 0;

  goToMilkDetailsPage({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MilkDetailsPage(milkId: id)),
    );
    refreshMilks();
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

  dateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          datePicked = dateTime;
          _selectedDay = DateFormat('dd/MM/yyyy').format(dateTime);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 200,
                decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.black),
                      left: BorderSide(width: 1.0, color: Colors.black),
                      right: BorderSide(width: 1.0, color: Colors.black),
                      bottom: BorderSide(width: 1.0, color: Colors.black),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Text(
                          _selectedDay,
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          dateTimePickerWidget(context);
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            dateTimePickerWidget(context);
                          },
                          tooltip: 'Please select a day',
                          icon: const Icon(Icons.calendar_month_outlined))
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton(
              onPressed: () {
                if (datePicked != null) {
                  milkDatabase
                      .readByDay(DateFormat('yyyy-MM-dd').format(datePicked!))
                      .then((value) {
                    setState(() {
                      milks = value;
                      quantityConsumed = milks.fold(
                          0,
                          (total, model) => total + (model.quantity != null ? model.quantity! : 0));
                    });
                  });
                } else {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => const AlertDialog(
                      // title: const Text('AlertDialog Title'),
                      content: SizedBox(
                        height: 50,
                        child: Column(
                          children: [
                            Icon(Icons.warning_amber_outlined),
                            Text(
                              'Please select a day',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Search',
                style: TextStyle(color: Colors.black),
              )),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: milks.isEmpty
                ? const Center(
                    child: Text('No Data available'),
                  )
                : Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                                        ? Text(
                                            ' | ${entry.quantity.toString()} ml')
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
          Text('Quantity of milk consumed : $quantityConsumed ml'),
        ],
      ),
    );
  }
}
