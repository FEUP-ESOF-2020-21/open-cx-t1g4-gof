import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/Question.dart';
import 'package:inquirescape/model/Conference.dart';

class PostQuestionPage extends StatefulWidget {
  final FirebaseController _fbController;
  final Widget _drawer;

  PostQuestionPage(this._fbController, this._drawer);

  @override
  _PostQuestionPage createState() => _PostQuestionPage();
}

class _PostQuestionPage extends State<PostQuestionPage> {
  final _formKey = GlobalKey<FormState>();

  final textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Post Question'),
          centerTitle: true,
        ),
        drawer: this.widget._drawer,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(height: 10),
              Text(
                "    Posting On: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: null,
                textAlign: TextAlign.left,
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Conference name",
                  style: TextStyle(fontSize: 20),
                  maxLines: null,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      //Question Body
                      margin: EdgeInsetsDirectional.only(
                          top: 20.0, start: 20.0, end: 20.0),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),

                      child: TextFormField(
                        controller: textController,
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 8),
                          hintText: 'Please write down your question',
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
                  ],
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [saveButton(context)],
      ),
    );
  }

  Widget saveButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Validate will return true if the form is valid, or false if
        // the form is invalid.
        if (_formKey.currentState.validate()) {
          // widget._question.description = textController.text;
          Navigator.pop(context);
        }
      },
      child: Icon(Icons.save),
    );
  }
}
