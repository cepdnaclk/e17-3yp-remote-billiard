   
import 'package:flutter/material.dart';
import './SelectOptions.dart';


class ExitPage extends StatefulWidget {
  static const String id = 'ExitPage';

  @override
  _ExitPageState createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Container(
     
     decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.black])),
      child: Scaffold(
          // By defaut, Scaffold background is white
          // Set its value to transparent
          backgroundColor: Colors.transparent,
           body: Center(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
            
            
            Container(
             margin: EdgeInsets.all(25), 
             child:Image.asset("./assets/logo.png",
             height: 50,
             width: 100,
             )
            
            ),
           
            Text("You are the winner",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  fontFamily: "Open sans",
                  letterSpacing: 5,
                  color: Colors.blue[100],
                ),) , 
            Container(  
              margin: EdgeInsets.all(25),  
              child: FlatButton(  
                child: Text('Play New Game', style: TextStyle(fontSize: 17.0),),  
                color: Colors.blue[200],  
                textColor: Colors.black,  
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder:(context)=>SelectOptions())
                  );

                },  
              ),  
            ),  
            Container(  
              margin: EdgeInsets.all(25),  
              child: FlatButton(  
                child: Text('Exit', style: TextStyle(fontSize: 17.0),),  
                color: Colors.blue[200],  
                textColor: Colors.black,  
                onPressed: () {
                  //Navigator.push(context,
                  //MaterialPageRoute(builder:(context)=>FindPlayerPage())
                  //);

                },  
              ),  
            ),  
            
              
            ])
                 
          )),
    );
  }
}