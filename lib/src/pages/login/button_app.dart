import 'package:flutter/material.dart';
import 'package:fizz_app/src/utils/colors.dart' as utils;


class ButtonApp extends StatelessWidget {

  Color color;
  Color textColor;
  String text;
  IconData icon;
  Function onPressed;

  ButtonApp({
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.icon = Icons.arrow_forward_ios,
    this.onPressed,
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        onPressed();
      },
      color: color,
      textColor: textColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                  text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 50,
              child: CircleAvatar(
                radius: 15,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromRGBO(220, 0, 29, 1),
              ),
            ),
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}
