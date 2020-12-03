import 'package:flutter/material.dart';
import 'package:inquirescape/widgets/tags/Tag.dart';

class TagEditor extends StatefulWidget {
  final List<String> tags;

  TagEditor({Key key, @required this.tags}) : super(key: key);

  @override
  _TagEditorState createState() => _TagEditorState();
}

class _TagEditorState extends State<TagEditor> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        children: <Widget>[
          if (this.widget.tags.isNotEmpty)
            Container(
              height: 30,
              color: Colors.transparent,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: this.widget.tags.length,
                itemBuilder: (BuildContext context, int index) => Tag(
                  tagName: widget.tags[index],
                  onTap: () => this.setState(() => this.widget.tags.removeAt(index)),
                ),
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
