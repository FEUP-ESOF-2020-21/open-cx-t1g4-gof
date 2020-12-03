import 'package:flutter/material.dart';
import 'package:inquirescape/widgets/tags/Tag.dart';

class TagDisplayer extends StatelessWidget {
  final List<String> tags;
  final double tagSize;

  TagDisplayer({Key key, @required this.tags, this.tagSize = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.tagSize + 6,
      color: Colors.transparent,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: this.tags.length,
        itemBuilder: (BuildContext context, int index) => Tag(tagName: this.tags[index]),
      ),
    );
  }
}
