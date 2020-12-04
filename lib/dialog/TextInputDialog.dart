import 'package:flutter/material.dart';
import 'package:inquirescape/pages/Validators.dart';
import 'package:inquirescape/themes/MyTheme.dart';

class _TextInputDialog extends StatefulWidget {
  final String query, label, hintText, buttonText;
  final TextInputType inputType;
  final Future<List<dynamic>> Function(String) action;

  _TextInputDialog({
    Key key,
    @required this.query,
    @required this.label,
    @required this.hintText,
    @required this.buttonText,
    @required this.action,
    this.inputType,
  }) : super(key: key);

  @override
  _TextInputDialogState createState() => new _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  String _value;
  bool _successStatus;
  String _successStatusMessage;
  bool _waitingResponse = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _decideBody();
  }

  Widget _decideBody() {
    if (_waitingResponse)
      return Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator()]);
    return _successStatus == null ? _textInput() : _result();
  }

  Widget _result() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Divider(color: Colors.transparent, height: 20),
        Icon(_successStatus ? Icons.check_circle_outline : Icons.cancel_outlined, size: 60,),
        Divider(color: Colors.transparent, height: 10),
        Text(_successStatusMessage),
        Divider(color: Colors.transparent, height: 20),
        RaisedButton(
          child: Text("Ok"),
          color: MyTheme.theme.primaryColor,
          onPressed: () {
            Navigator.of(context).pop(_value);
          },
        ),
      ],
    );
  }

  Widget _textInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
                child: TextField(
              keyboardType: widget.inputType,
              autofocus: true,
              decoration: InputDecoration(labelText: widget.label, hintText: widget.hintText),
              onChanged: (value) {
                _value = value;
              },
            ))
          ],
        ),
        Divider(color: Colors.transparent, height: 20),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlineButton(onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            RaisedButton(
              child: Text(widget.buttonText),
              color: MyTheme.theme.primaryColor,
              onPressed: () {
                if (_value != null && _value.isNotEmpty && Validators.validateEmail(_value)) {
                  _waitingResponse = true;
                  setState(() {});
                  widget.action(_value).then((l) {
                    _waitingResponse = false;
                    _successStatus = l[0];
                    _successStatusMessage = l[1];
                    print(_successStatus);
                    print(_successStatusMessage);
                    setState(() {});
                  });
                }
              },
            ),
          ],
        )
      ],
    );
  }
}

Future<String> textInputDialog(
  BuildContext context, {
  @required String query,
  @required String label,
  @required String hintText,
  @required String buttonText,
  @required Future<List<dynamic>> Function(String) action,
  TextInputType inputType,
  bool dismissable: true,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: dismissable, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(query),
        content: _TextInputDialog(
          query: query,
          label: label,
          hintText: hintText,
          buttonText: buttonText,
          inputType: inputType,
          action: action,
        ),
      );
    },
  );
}
