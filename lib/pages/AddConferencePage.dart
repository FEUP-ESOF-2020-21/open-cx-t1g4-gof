import 'dart:ui';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/widgets/tags/TagEditor.dart';
import 'package:inquirescape/themes/MyTheme.dart';

class AddConferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddConferencePageState();
}

class _AddConferencePageState extends State<AddConferencePage> {
  TimeOfDay selectedTime;
  DateTime start;
  final timeController = TextEditingController();
  final List<String> tags = [];

  final TextEditingController titleController = TextEditingController(),
      speakerController = TextEditingController(),
      descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Talk"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsetsDirectional.only(top: 10.0, bottom: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: titleController,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Title',
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
                            TimeOfDay td = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );

                            if (td == null) return;

                            selectedTime = td;
                            timeController.text = selectedTime.format(context);
                          },
                        ),
                      ),
                      Container(
                        //Description
                        margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),

                        child: TextFormField(
                          controller: descriptionController,
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
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: speakerController,
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
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TagEditor(tags: this.tags),
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
                          color: MyTheme.theme.primaryColor,
                          child: Text(
                            "Create",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          onPressed: () async {
                            if (titleController.text.isEmpty ||
                                descriptionController.text.isEmpty ||
                                speakerController.text.isEmpty ||
                                start == null ||
                                selectedTime == null) {
                              _showSnackBar(context, "All fields must be filled!");
                              return;
                            }
                            start = start.add(new Duration(hours: selectedTime.hour, minutes: selectedTime.minute));

                            showDialog(
                              context: context,
                              builder: (context) => SafeArea(
                                child: AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text("Creating talk..."),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            try {
                              Conference created = await FirebaseController.addConference(Conference.withoutRef(
                                  titleController.text,
                                  descriptionController.text,
                                  speakerController.text,
                                  start,
                                  tags));
                              await FirebaseController.addConferenceToModerator(created, FirebaseController.currentMod)
                                  .then((_) { Navigator.pop(context); Navigator.pop(context); });
                            } on Exception {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldState s = Scaffold.of(context);
    s.removeCurrentSnackBar();
    s.showSnackBar(SnackBar(
      duration: Duration(
        milliseconds: 800,
      ),
      width: 200,
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ));
  }
}
