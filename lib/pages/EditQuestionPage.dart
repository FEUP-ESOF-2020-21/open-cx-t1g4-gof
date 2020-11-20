import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/model/Question.dart';

class EditQuestionPage extends StatefulWidget {
  final Question _question;
  final String oldDescript;

  EditQuestionPage(this._question) : this.oldDescript = _question.content;

  @override
  _EditQuestionPage createState() => _EditQuestionPage();
}

class _EditQuestionPage extends State<EditQuestionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Question'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding:
                        new EdgeInsets.symmetric(vertical: 25.0, horizontal: 8),
                  ),
                  minLines: 6,
                  maxLines: null,
                  initialValue: widget._question.content,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Empty description.";
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    // bool hasChanged = value != this.widget.oldDescript;
                    // if (hasChanged) widget._question.updateContent(value);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
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
          _formKey.currentState.save();
        }
      },
      child: Icon(Icons.save),
    );
  }
}
