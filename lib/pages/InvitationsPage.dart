import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';

import 'package:inquirescape/model/Invitation.dart';
import 'package:inquirescape/widgets/TagDisplayer.dart';

class InvitationsPage extends StatefulWidget {
  final FirebaseController _fbController;
  final Widget _drawer;

  InvitationsPage(this._fbController, this._drawer);

  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  @override
  void initState() {
    this.widget._fbController.reloadInvites((arg) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Invitation> invitations = this.widget._fbController.myInvitations;

    return RefreshIndicator(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pending Invitations"),
          centerTitle: true,
        ),
        drawer: this.widget._drawer,
        body: (invitations == null || invitations.isEmpty)
            ? _noInvites(context)
            : _inviteList(context, invitations),
      ),
      onRefresh: this._onRefresh,
    );
  }

  Future<void> _onRefresh() async {
    // this.widget._fbController.reloadInvites((arg) {
    //   setState(() {});
    // });
  }

  Widget _noInvites(BuildContext context) {
    return Center(
      child: Text(
        "No Invitations",
        style: TextStyle(color: Colors.grey, fontSize: 30),
      ),
    );
  }

  Widget _inviteList(BuildContext context, List<Invitation> invitations) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: invitations.length,
      itemBuilder: (BuildContext context, int index) =>
          _inviteCard(context, invitations[index], index),
    );
  }

  Widget _inviteCard(BuildContext context, Invitation invite, int index) {
    const TextStyle headerStyle = TextStyle(fontSize: 15);
    const TextStyle infoStyle = TextStyle(fontSize: 20);
    const TextStyle dateStyle = TextStyle(fontSize: 12);

    return Padding(
      padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Title",
                  style: headerStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(invite.conference.title, style: infoStyle),
                Divider(
                  color: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Speaker",
                            style: headerStyle,
                          ),
                          Text(
                            invite.conference.speaker,
                            style: infoStyle,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: headerStyle,
                          ),
                          Text(
                            this.fromDateTime(invite.conference.startDate),
                            style: dateStyle,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                TagDisplayer(
                  tags: invite.conference.topics,
                  tagColor: Colors.white,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 160),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invited by:",
                              style: headerStyle,
                            ),
                            Text(
                              invite.user.username,
                              style: infoStyle,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          FlatButton(
                            onPressed: () {
                              this.widget._fbController.acceptInvite(invite);
                              // TODO refresh page state
                            },
                            child: Icon(Icons.check, color: Colors.green),
                          ),
                          FlatButton(
                            onPressed: () {
                              this.widget._fbController.rejectInvite(invite);
                            },
                            child: Icon(Icons.close, color: Colors.red),
                          )
                        ],
                      ),
                    ]),
              ],
            ),
          ),
        ),
      ),
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
