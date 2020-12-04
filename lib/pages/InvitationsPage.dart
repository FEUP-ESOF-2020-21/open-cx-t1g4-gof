import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Invitation.dart';
import 'package:inquirescape/widgets/SuchEmpty.dart';
import 'package:inquirescape/widgets/tags/TagDisplayer.dart';

class InvitationsPage extends StatefulWidget {
  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  @override
  void initState() {
    FirebaseController.reloadInvites((arg) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Invitation> invitations = FirebaseController.myInvitations;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Invitations"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: (invitations == null || invitations.isEmpty) ? _noInvites(context) : _inviteList(context, invitations),
      ),
    );
  }

  Future<void> _onRefresh() async {
    FirebaseController.reloadInvites((_) => setState(() {}));
  }

  Widget _noInvites(BuildContext context) {
    return Stack(
      children: [
        Center(child: SuchEmpty(extraText: "No Invites", sizeFactor: 0.5)),
        ListView(),
      ],
    );
  }

  Widget _inviteList(BuildContext context, List<Invitation> invitations) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: invitations.length,
      itemBuilder: (BuildContext context, int index) => _inviteCard(context, invitations[index]),
    );
  }

  Widget _inviteCard(BuildContext context, Invitation invite) {
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
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                          FirebaseController.acceptInvite(invite);
                          setState(() {});
                        },
                        child: Icon(Icons.check, color: Colors.green),
                      ),
                      FlatButton(
                        onPressed: () {
                          FirebaseController.rejectInvite(invite);
                          setState(() {});
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
