import 'package:flutter/material.dart';
import 'package:inquirescape/dialog/TextInputDialog.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/model/Moderator.dart';
import 'package:inquirescape/themes/MyTheme.dart';
import 'package:inquirescape/widgets/tags/TagDisplayer.dart';

class ConferenceFullPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const TextStyle infoStyle = TextStyle(fontSize: 20);

    Conference conference = FirebaseController.currentConference;

    const Divider headerInfoDivider = Divider(
      color: Colors.transparent,
      height: 5,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Current Talk"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsetsDirectional.only(start: 8, top: 8, end: 8, bottom: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Title",
                  style: headerStyle,
                  maxLines: null,
                ),
                headerInfoDivider,
                Text(
                  conference.title,
                  style: infoStyle,
                  maxLines: null,
                ),
                const Divider(color: Colors.transparent),
                const Text(
                  "Speaker",
                  style: headerStyle,
                  maxLines: null,
                ),
                headerInfoDivider,
                Text(
                  conference.speaker,
                  style: infoStyle,
                  maxLines: null,
                ),
                const Divider(color: Colors.transparent),
                const Text(
                  "Date & Time",
                  style: headerStyle,
                  maxLines: null,
                ),
                headerInfoDivider,
                Text(
                  this.fromDateTime(conference.startDate),
                  style: infoStyle,
                  maxLines: null,
                ),
                const Divider(color: Colors.transparent),
                const Text(
                  "Identifier",
                  style: headerStyle,
                  maxLines: null,
                ),
                headerInfoDivider,
                Text(
                  conference.docRef.id,
                  style: infoStyle,
                  maxLines: null,
                ),
                const Divider(color: Colors.transparent),
                const Text(
                  "Topics",
                  style: headerStyle,
                  maxLines: null,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: TagDisplayer(
                    tags: conference.topics,
                    tagSize: 18,
                  ),
                ),
                const Divider(color: Colors.transparent),
                const Text(
                  "Description",
                  style: headerStyle,
                  maxLines: null,
                ),
                const Divider(color: Colors.transparent, height: 5),
                Text(
                  conference.description == "" ? "(no description added)" : conference.description,
                  style: infoStyle,
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: Text(
            "Invite Moderator",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          color: MyTheme.theme.primaryColor,
          onPressed: () => _inviteModerator(context),
        ),
      ],
    );
  }

  void _inviteModerator(BuildContext context) async {
    textInputDialog(
      context,
      query: "Invite Moderator",
      hintText: "eg. moderator@gmail.com",
      buttonText: "Invite",
      label: "Email",
      dismissable: false,
      action: (String value) async {
        Moderator recipient = await FirebaseController.getModeratorByMail(value);
        if (recipient == null) {
          return [false, "Moderator with email '" + value + "' not found"];
        }

        if (await FirebaseController.isInConference(recipient, FirebaseController.currentConference)) {
          return [false, "Moderator " + recipient.username + " is already in that talk"];
        }

        if (await FirebaseController.isInvitedTo(recipient, FirebaseController.currentConference)) {
          return [false, "Moderator " + recipient.username + " is already invited to that talk"];
        }

        if (await FirebaseController.inviteModerator(
            recipient, FirebaseController.currentConference, FirebaseController.currentMod, verifiedExistance: true)) {
          return [true, "Invite sent to " + recipient.username];
        }
        else {
          return [false, "Failed to send invite to " + recipient.username];
        }
      },
      inputType: TextInputType.emailAddress,
    );
  }

  String fromDateTime(DateTime d) {
    return d.day.toString().padLeft(2, "0") +
        "-" +
        d.month.toString().padLeft(2, "0") +
        "-" +
        d.year.toString().padLeft(4, "0") +
        " " +
        d.hour.toString().padLeft(2, "0") +
        ":" +
        d.minute.toString().padLeft(2, "0");
  }
}
