import 'dart:ui';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';

class AddConferencePage extends StatefulWidget {
  // final FirebaseController _fbController;

  @override
  State<StatefulWidget> createState() => _AddConferencePageState();
}

class _AddConferencePageState extends State<AddConferencePage> {
  TimeOfDay selectedTime;
  DateTime start;
  final timeController = TextEditingController();
  String desc;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Conference"),
          centerTitle: true,
        ),
        drawer: InquireScapeDrawer(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 10.0, bottom: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        top: 20.0, start: 20.0, end: 20.0),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Conference Name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        top: 20.0, start: 20.0, end: 20.0),
                    alignment: Alignment.centerLeft,
                    child: DateField(
                      label: 'Start Date',
                      onDateSelected: (DateTime value) {
                        setState(() {
                          start = value;
                        });
                      },
                      selectedDate: start,
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        top: 20.0, start: 20.0, end: 20.0),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      readOnly: true,
                      controller: timeController,
                      decoration: InputDecoration(hintText: 'Select Time'),
                      onTap: () async {
                        selectedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                      },
                    ),
                  ),
                  Container(
                    //Description
                    margin: EdgeInsetsDirectional.only(
                        top: 20.0, start: 20.0, end: 20.0),
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 8),
                      ),
                      minLines: 6,
                      maxLines: null,
                      initialValue: 'Description',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Empty description.";
                        }
                        desc = value;
                        return null;
                      },
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      child: Text("Add", style: TextStyle(fontSize: 20.0)),
                      onPressed: () {
                        start.add(new Duration(
                            hours: selectedTime.hour,
                            minutes: selectedTime.minute));
                        //TODO save conference
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
