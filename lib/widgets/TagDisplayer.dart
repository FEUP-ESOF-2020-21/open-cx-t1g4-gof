import 'package:flutter/material.dart';

class TagDisplayer extends StatelessWidget {
  final List<String> tags;
  final double tagSize;
  final Color borderColor, tagColor;

  TagDisplayer({Key key, @required this.tags, this.tagSize = 16, this.borderColor = Colors.grey, this.tagColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.tagSize + 6,
      color: Colors.transparent,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: this.tags.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              color: this.tagColor,
              border: Border.all(color: this.borderColor),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.only(left: 4, right: 4),
            child: Text(
              "  " + this.tags[index] + "  ",
              style: TextStyle(fontSize: this.tagSize),
            ),
          );
        },
      ),
    );
  }
}
