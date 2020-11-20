import 'dart:ui';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';
import 'package:inquirescape/widgets/TagEditorWidget.dart';

class AddConferencePage extends StatefulWidget {
  final FirebaseController _fbController;
  final Widget _drawer;

  AddConferencePage(this._fbController, this._drawer);

  @override
  State<StatefulWidget> createState() => _AddConferencePageState();
}

class _AddConferencePageState extends State<AddConferencePage> {
  TimeOfDay selectedTime;
  DateTime start;
  final timeController = TextEditingController();
  String desc;
  List<String> tags = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Conference"),
          centerTitle: true,
        ),
        drawer: this.widget._drawer,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 10.0, bottom: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Conference Name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
                    alignment: Alignment.centerLeft,
                    child: DateField(
                      firstDate: DateTime.now(),
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
                    margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
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
                        timeController.text = selectedTime.format(context);
                      },
                    ),
                  ),
                  Container(
                    //Description
                    margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
                    alignment: Alignment.centerLeft,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),

                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 8),
                        hintText: 'Description',
                      ),
                      minLines: 6,
                      maxLines: null,
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
                    margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Speaker',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    //Description
                    margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
                    alignment: Alignment.centerLeft,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                    child: TagEditorWidget(tags: this.tags),
                  ),
                  Divider(
                    color: Colors.transparent,
                    thickness: 0,
                    height: 12,
                  ),
                  Container(
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Create",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        start.add(new Duration(hours: selectedTime.hour, minutes: selectedTime.minute));
                        //TODO save conference
                        //TODO on error show a SnackBar
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
