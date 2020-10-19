import 'package:flutter/material.dart';
import 'note_list.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      home:ProgressBar(),
    );
  }
}

class ProgressBar extends StatefulWidget {
  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5) , () => Navigator.push(context,MaterialPageRoute(
        builder: (context){
          return NoteList();
        }
    ) ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // first element in the stack
          Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),),
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50.0,
                      child: Icon(Icons.insert_drive_file, size: 60,
                        color: Colors.orangeAccent,),
                    ),
                    SizedBox(height: 10,),
                    Text('Note Keeper',
                      style: TextStyle(fontSize: 23.0, color: Colors.black , fontFamily: 'Varela'),)
                  ],
                ),
              ),
              //second element in the stack
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    CircularProgressIndicator(
                      backgroundColor: Colors.black45,
                      strokeWidth: 4,
                    ),
                    SizedBox(height: 20.0,),
                    Text('Task Reminder \n For everyone.',
                      style: TextStyle(color:Colors.black45 , fontWeight: FontWeight.bold,fontSize: 18.0 , fontFamily: 'Varela'),),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}