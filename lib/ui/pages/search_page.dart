import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../data/milk_database.dart';
import '../../data/milk_model.dart';
import 'milk_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  MilkDatabase milkDatabase = MilkDatabase.instance;
  String selectedStartDate = 'Tap to select start date';
  String selectedEndDate = 'Tap to select end date';
  List<MilkModel> milks = [];
  DateTime? datePicked;
  DateTime? startDateTimePicked;
  DateTime? endDateTimePicked;
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

  startDateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          startDateTimePicked = dateTime;
          selectedStartDate = DateFormat('dd/MM/yyyy').format(dateTime);
        });
      },
    );
  }

  endDateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: startDateTimePicked,
      minDateTime: startDateTimePicked,
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          endDateTimePicked = dateTime;
          selectedEndDate = DateFormat('dd/MM/yyyy').format(dateTime);
        });
        milkDatabase
            .readByDateInterval(startDateTimePicked!.toIso8601String(),
                endDateTimePicked!.toIso8601String())
            .then((value) {
          setState(() {
            milks = value;
            quantityConsumed = milks.fold(
                0,
                (total, model) =>
                    total + (model.quantity != null ? model.quantity! : 0));
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 225,
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
                          selectedStartDate,
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            startDateTimePicked = null;
                            selectedStartDate = 'Tap to select start date';
                            selectedEndDate = 'Tap to select end date';
                            milks = [];
                            quantityConsumed = 0;
                          });
                          startDateTimePickerWidget(context);
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              startDateTimePicked = null;
                              selectedStartDate = 'Tap to select start date';
                              selectedEndDate = 'Tap to select end date';
                              milks = [];
                              quantityConsumed = 0;
                            });
                            startDateTimePickerWidget(context);
                          },
                          tooltip: 'Please select a date',
                          icon: const Icon(Icons.calendar_month_outlined))
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: 225,
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
              child: startDateTimePicked != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Text(
                            selectedEndDate,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            endDateTimePickerWidget(context);
                          },
                        ),
                        IconButton(
                            onPressed: () {
                              endDateTimePickerWidget(context);
                            },
                            tooltip: 'Please select a date',
                            icon: const Icon(Icons.calendar_month_outlined))
                      ],
                    )
                  : const Text('Please select start date above'),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Visibility(
              visible: milks.isNotEmpty,
              child: Text('Quantity of milk consumed : $quantityConsumed ml')),
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
          ),

        ],
      ),
    );
  }
}
