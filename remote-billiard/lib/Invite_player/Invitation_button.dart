
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const ConfirmButton({
    Key key,
    this.text,
    this.press,
    this.color,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50),
      width: size.width * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        
        /*child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "Acme",
              letterSpacing: 5,
            ),
          ),
        ),*/
          child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(side: BorderSide(
            color: Colors.amber[700],
            width:3,
            style: BorderStyle.solid
          ), borderRadius: BorderRadius.circular(20)),
                color:Colors.amberAccent[200],
                child: Text(text,
                  style:GoogleFonts.raleway(
              textStyle: TextStyle(fontSize: 19.0),
               fontWeight: FontWeight.bold,
                letterSpacing: 3,
        
                ),),
               
                textColor: Colors.blue[900],
                onPressed: press,
              ),
      ),
    );
  }
}