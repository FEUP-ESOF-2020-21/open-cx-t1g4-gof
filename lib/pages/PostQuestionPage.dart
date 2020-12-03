import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/model/Moderator.dart';

class PostQuestionPage extends StatefulWidget {
  Moderator _mod;
  Conference _conference;

  PostQuestionPage() {
    this._mod = FirebaseController.currentMod;
    this._conference = FirebaseController.currentConference;
  }

  @override
  _PostQuestionPage createState() => _PostQuestionPage();
}

class _PostQuestionPage extends State<PostQuestionPage> {
  final _formKey = GlobalKey<FormState>();

  final textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool unloaded = (this.widget._mod == null || this.widget._conference == null);
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Question'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: unloaded ? _conferenceUnloaded(context) : _onConferenceLoaded(context),
      ),
      persistentFooterButtons: unloaded ? null : [saveButton(context)],
    );
  }

  Widget _conferenceUnloaded(BuildContext context) {
    return Center(
      child: Text(
        "No conference selected\nSelect conference in 'My Conferences' tab",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _onConferenceLoaded(BuildContext context) {
    return SingleChildScrollView(
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
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
            child: Text(
              this.widget._conference.title,
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
                  margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
                  alignment: Alignment.centerLeft,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),

                  child: TextFormField(
                    controller: textController,
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 8),
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
    );
  }

  Widget saveButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // Validate will return true if the form is valid, or false if
        // the form is invalid.
        if (_formKey.currentState.validate()) {
          DateTime postDate = DateTime.now();
          Question question = new Question.withoutRef(
              textController.text, postDate, widget._mod.docRef.id, widget._mod.username, "InquireScape");

          await FirebaseController.addQuestionAndUpdate(widget._conference, question);
        }
      },
      child: Icon(Icons.save),
    );
  }
}
