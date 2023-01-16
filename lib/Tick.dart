import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getTick(context, int text, String question, bool correct, Color color,
    IconData icon) {
  String Question = question;
  bool CorrectAnswer = correct;
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Container(
            child: Column(
              children: [
                TextElement('Question: $Question'),
                TextElement('Correct Answer: $CorrectAnswer'),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      //The user picked true.
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    child: Container(
      child: Row(
        children: [
          Text(
            '${text}',
            style: TextStyle(color: Colors.white),
          ),
          Icon(
            icon,
            color: color,
          ),
        ],
      ),
    ),
  );
}

Widget TextElement(String text) {
  return Expanded(
    flex: 1,
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
