import 'package:flutter/material.dart';

class TagEditorWidget extends StatefulWidget {
  final List<String> tags;

  TagEditorWidget({Key key, @required this.tags}) : super(key: key);

  @override
  _TagEditorWidgetState createState() => _TagEditorWidgetState();
}

class _TagEditorWidgetState extends State<TagEditorWidget> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        children: <Widget>[
          if (!this.widget.tags.isEmpty)
            Container(
              height: 30,
              color: Colors.transparent,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: this.widget.tags.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    margin: EdgeInsets.only(left: 4, right: 4),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "  " + this.widget.tags[index] + "  ",
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          padding: EdgeInsets.only(right: 4),
                          iconSize: 23,
                          constraints: BoxConstraints(),
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey[700],
                          ),
                          onPressed: () => this.setState(() => this.widget.tags.removeAt(index)),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  );
                },
              ),
            ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Tags',
                  ),
                  controller: this._controller,
                  onSubmitted: this.addTag,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline_rounded),
                onPressed: this.buttonAddTag,
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void buttonAddTag() {
    this.addTag(_controller.text);
  }

  void addTag(String value) {
    if (value != null && value.trim() != "" && !this.widget.tags.contains(value)) {
      this.setState(() {
        this.widget.tags.add(value);
      });
    }
    this._controller.clear();
  }
}
