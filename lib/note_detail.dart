import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/database/note.dart';
import 'package:notekeeper/database/database_helper.dart';

class NoteDetails extends StatefulWidget {
 final String appBarTitle ;
 final Note note ;
  NoteDetails(this.note , this.appBarTitle);
  @override
  _NoteDetailsState createState() => _NoteDetailsState(this.note , this.appBarTitle);
}

class _NoteDetailsState extends State<NoteDetails> {
  var  _keyForm1 = GlobalKey<FormState>();
   String appBarTitle ;
   Note note ;
   DatabaseHelper helper = DatabaseHelper();
  _NoteDetailsState(this.note , this.appBarTitle);
  static var _priorities = ['High' , 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    titleController.text = note.title;
    descriptionController.text = note.description ;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              moveToLastScreen();
            },
          ),
          title: Text(appBarTitle , style:TextStyle(fontFamily: 'Varela')),
        ),
        body: Form(
          key : _keyForm1 ,
          child: Padding (
            padding: EdgeInsets.only(top: 15.0 , left: 10.0 , right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String item){
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item ,style:TextStyle(fontFamily: 'Varela')),
                      );
                    }).toList(),
                    onChanged: (valueSelectedByUser){
                      setState(() {
                        updatePriorityAsInt(valueSelectedByUser);
                      });
                    },
                    value: getPriorityAsString(note.priority),
                  ),
                ),
               Padding(
                 padding: EdgeInsets.only(top: 15.0 , bottom: 15.0),
                 child: TextFormField(
                   validator:(String value){
                     String message  ;
                     if (value.isEmpty){
                       message = 'Please Enter the title ' ;
                     }
                     return message ;
                   },
                   style: TextStyle(fontFamily:'Varela' ,fontSize: 20 ),
                   controller: titleController,
                   onChanged: (value){
                     updateTitle();
                   },
                   decoration: InputDecoration(
                     errorStyle: TextStyle(fontSize: 15),
                     labelText: 'Title',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(5.0),
                     )
                   ),
                 ),
               ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0 , bottom: 15.0),
                  child: TextFormField(
                    validator: (String value){
                      String message ;
                      if (value.isEmpty){
                        message = ' Description isn\'t valid' ;
                      }
                     return message ;
                    },
                    maxLines: 5,
                    style: TextStyle(fontFamily:'Varela' ,fontSize: 20 ,),
                    controller: descriptionController,
                    onChanged: (value){
                      updateDescription();
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 15),
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0 , bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          elevation: 0.0,
                          onPressed: (){
                              if(_keyForm1.currentState.validate()){
                                _save();
                              }
                          },
                          color: Colors.orangeAccent,
                          child: Text('Save',style:TextStyle(fontFamily: 'Varela'), textScaleFactor: 1.3,) ,
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      Expanded(
                        child: RaisedButton(
                          elevation: 0.0,
                          onPressed: (){
                            if(_keyForm1.currentState.validate()){
                              _delete() ;
                            }
                          },
                          color: Colors.orangeAccent,
                          child: Text('Delete' ,style:TextStyle(fontFamily: 'Varela'), textScaleFactor: 1.3,) ,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
 // section of helper functions
  void moveToLastScreen(){
    Navigator.pop(context , true);
  }
  void updatePriorityAsInt(String value){
    switch (value){
      case 'High':
        note.priority = 1 ;
        break;
      case 'Low':
        note.priority = 2 ;
    }
  }

  String getPriorityAsString(int value){
    String priority ;
    switch(value){
      case 1:
        priority = _priorities[0];
        break ;
      case 2:
        priority = _priorities[1];
        break ;
    }
    return priority ; 
  }

  void updateTitle(){
    note.title = titleController.text ;
  }
  void updateDescription(){
    note.description = descriptionController.text ;
  }

  void _save()async{
    moveToLastScreen() ;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result ;
    if (note.id != null){
      result = await helper.updateNote(note);
    } else  {
      result = await helper.insertNote(note);
    }
    if (result != 0 ){
      _showAlterDialog('Status' , 'Note Saved Successfully');
    }else{
      _showAlterDialog('Status ' , 'Problem Saving Note');
    }
  }

  void _delete ()async{
    moveToLastScreen() ;
    if (note.id == null){
      _showAlterDialog('Status', 'you trying to delete an empty note');
      return ;
    }
    int result = await helper.deleteNote(note.id );
    if(result != 0){
      _showAlterDialog('Status', 'Note Deleted Successfully ');
    }else{
      _showAlterDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlterDialog(String title , String message){
    showDialog(context: context ,
    builder: (_)=> AlertDialog(
      title:Text(title),
      content: Text(message),
    ));
  }
}
