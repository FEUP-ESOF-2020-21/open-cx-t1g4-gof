import 'package:flutter/material.dart';
import 'package:inquirescape/themes/MyTheme.dart';

class SuchEmpty extends StatelessWidget {
  final String extraText;
  final double mainFontSize, extraFontSize;
  final double sizeFactor;

  SuchEmpty({this.extraText, this.sizeFactor: 1, this.mainFontSize: 18, this.extraFontSize: 28});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: sizeFactor,
      heightFactor: sizeFactor,
      child: Column(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              // child: Icon(Icons.bathtub_rounded, color: MyTheme.theme.accentColor,),
              child: Icon(
                Icons.pest_control_rodent_outlined,
                color: MyTheme.theme.accentColor,
              ),
            ),
          ),
          Text("Wow such empty", style: TextStyle(fontSize: mainFontSize)),
          if (extraText != null)
            Text(extraText, style: TextStyle(fontSize: extraFontSize)),
        ],
      ),
    );
  }
}
