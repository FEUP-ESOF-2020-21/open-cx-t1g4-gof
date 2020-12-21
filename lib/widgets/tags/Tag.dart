import 'package:flutter/material.dart';
import 'package:inquirescape/themes/MyTheme.dart';

class Tag extends StatelessWidget {
  final String tagName;
  final double tagSize;
  final void Function() onTap;

  Tag({@required this.tagName, this.onTap, this.tagSize = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyTheme.theme.backgroundColor,
        // border: Border.all(color: MyTheme.theme.primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: EdgeInsets.only(left: 4, right: 4),
      child: Center(
        child: Row(
          children: [
            Text(
              "  " + tagName + "  ",
              style: TextStyle(fontSize: tagSize),
            ),
            if (this.onTap != null)
              IconButton(
                padding: EdgeInsets.only(right: 4),
                iconSize: 22,
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.close,
                ),
                onPressed: onTap,
              ),
          ],
        ),
      ),
    );
  }
}
