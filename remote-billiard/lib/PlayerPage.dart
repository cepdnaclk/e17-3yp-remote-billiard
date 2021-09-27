   
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:yoyo_player/yoyo_player.dart';
import 'ChoosePocket.dart';
//import 'package:video_player/video_player.dart';
  import 'ChatPage.dart';
    import 'ExitPage.dart';

class PlayerPage extends StatefulWidget {
   static const String id='PlayerPage';
  const PlayerPage({
    Key key,
     this.streamUrl,
  }) : super(key: key);

  static Route<dynamic> route(String url) {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return PlayerPage(streamUrl: url);
      },
    );
  }

  final String streamUrl;

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
   // VideoPlayerController _controller;
   final url = "https://www.youtube.com/watch?v=QDFAZKefV34";


  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }
   /*@override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }*/

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
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
              /*Container(
              child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: VideoPlayer(_controller),
                )
              : Container(),
              
        ),
        Container(
          floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
        ),*/
              Expanded(
              flex: 3,
              child: YoYoPlayer(
                aspectRatio: 16 / 9,
                url: widget.streamUrl,
                videoStyle: VideoStyle(),
                videoLoadingStyle: VideoLoadingStyle(),
              ),
            ),
            Container( 
               margin: EdgeInsets.all(25),
               child:Text("Your Turn",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    fontFamily: "Open sans",
                    letterSpacing: 5,
                    color: Colors.blue[100],
                  ),) , 
            ),
              Container(  
                margin: EdgeInsets.all(25),  
                child: FlatButton(  
                  child: Text('Call For Foul', style: TextStyle(fontSize: 17.0),),  
                  color: Colors.blue[200],  
                  textColor: Colors.black,  
                  onPressed: () {
                    //Navigator.push(context,
                    //MaterialPageRoute(builder:(context)=>FindPlayerPage())
                    //);

                  },  
                ),  
              ),  
              Container(  
                margin: EdgeInsets.all(25),  
                child: FlatButton(  
                  child: Text('Pause Game', style: TextStyle(fontSize: 17.0),),  
                  color: Colors.blue[200],  
                  textColor: Colors.black,  
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder:(context)=>ExitPage())
                    );

                  },  
                ),  
              ),  
              Container(
                margin: EdgeInsets.all(15),  
                child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder:(context)=>ChoosePocket()));
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Choose\nPocket'
                ),
              padding: EdgeInsets.all(25),
              shape: CircleBorder(),
              ),
                
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                      shape: CircleBorder(),
                  ),
                child: IconButton(
                  icon: Icon(Icons.chat),
                  iconSize: 48,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder:(context)=>ChatPage()));
        },
      ),
                ),
                
                
                ],
              )
              ),
                
              ])
                  
            )),
      );
  }
}