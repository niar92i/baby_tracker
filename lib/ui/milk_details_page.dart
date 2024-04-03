import 'package:baby_tracker/data/milk_database.dart';
import 'package:baby_tracker/data/milk_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

enum TypeLabel {
  breastmilk('Breastmilk', 'breastmilk'),
  milk('Milk', 'milk');

  const TypeLabel(this.label, this.value);

  final String label;
  final String value;
}

class MilkDetailsPage extends StatefulWidget {
  const MilkDetailsPage({super.key, this.milkId});

  final int? milkId;

  @override
  State<MilkDetailsPage> createState() => _MilkDetailsPageState();
}

class _MilkDetailsPageState extends State<MilkDetailsPage> {


  MilkDatabase milkDatabase = MilkDatabase.instance;

  final TextEditingController labelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double currentSliderValue = 20;
  TypeLabel initialSelection = TypeLabel.breastmilk;
  String? selectedType;
  late MilkModel milk;

  bool isLoading = false;
  bool isNewEntry = false;

  DateTime? datePicked;
  String _selectedDate = 'Tap to select date';

  @override
  void initState() {
    refreshEntries();
    super.initState();
  }

  refreshEntries() {
    if (widget.milkId == null) {
      setState(() {
        isNewEntry = true;
      });
      return;
    }
    milkDatabase.read(widget.milkId!).then((value) {
      setState(() {
        milk = value;
        _selectedDate = DateFormat('dd/MM/yyyy HH:mm').format(milk.takenDate);
        datePicked = milk.takenDate;
        if (milk.type == 'milk') {
          currentSliderValue = milk.quantity!.toDouble();
          initialSelection = TypeLabel.milk;
          selectedType = 'milk';
        }
      });
    });
  }

  createEntry() {
    setState(() {
      isLoading = true;
    });
    if (datePicked != null) {
      final model = MilkModel(
        type: selectedType ?? 'breastmilk',
        takenDate: isNewEntry ? datePicked! : milk.takenDate,
        quantity: selectedType == 'milk' ? currentSliderValue.round() : null,
        createdTime: DateTime.now(),
      );
      if (isNewEntry) {
        milkDatabase.create(model);
      } else {
        milkDatabase.update(MilkModel(
          id: milk.id,
          takenDate: datePicked ?? milk.takenDate,
          type: selectedType ?? 'breastmilk',
          quantity: selectedType == 'milk' ? currentSliderValue.round() : null,
          createdTime: milk.createdTime,
        ));
      }
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    } else {
      isLoading = false;
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SizedBox(
            height: 50,
            child: Column(
              children: [
                Icon(Icons.warning_amber_outlined),
                Text('Please select date', textAlign: TextAlign.center,),
              ],
            ),
          ),
          // actions: <Widget>[
          //   // TextButton(
          //   //   onPressed: () => Navigator.pop(context, 'Cancel'),
          //   //   child: const Text('Cancel'),
          //   // ),
          //   TextButton(
          //     onPressed: () => Navigator.pop(context, 'OK'),
          //     child: const Text('OK'),
          //   ),
          // ],
        ),
      );
    }
  }

  deleteEntry() {
    milkDatabase.delete(milk.id!);
    Navigator.pop(context);
  }

  dateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          datePicked = dateTime;
          _selectedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Visibility(
            visible: !isNewEntry,
            child: IconButton(
                onPressed:
                deleteEntry, icon: const Icon(Icons.delete)),
          ),
          IconButton(onPressed: createEntry, icon: const Icon(Icons.save)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownMenu<TypeLabel>(
                      initialSelection: initialSelection,
                      controller: labelController,
                      requestFocusOnTap: false,
                      label: const Text('Type'),
                      onSelected: (TypeLabel? type) {
                        setState(() {
                          selectedType = type?.value;
                        });
                      },
                      dropdownMenuEntries: TypeLabel.values
                          .map<DropdownMenuEntry<TypeLabel>>((TypeLabel type) {
                        return DropdownMenuEntry<TypeLabel>(
                          value: type,
                          label: type.label,
                        );
                      }).toList(),
                    ),
                    if (selectedType == 'milk')
                      Row(
                        children: [
                          const Text('Quantity: '),
                          Slider(
                            value: currentSliderValue,
                            max: 240,
                            divisions: 240,
                            label: currentSliderValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                currentSliderValue = value;
                              });
                            },
                          ),
                          Text('${currentSliderValue.round()} ml'),
                        ],
                      ),
                    const SizedBox(height: 10,),
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
                                _selectedDate,
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
                                tooltip: 'Tap to open date picker',
                                icon: const Icon(Icons.calendar_month_outlined))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
