import 'package:flutter/material.dart';
import 'package:notekeeper/note_detail.dart';
import 'dart:async';
import 'package:notekeeper/database/note.dart';
import 'package:notekeeper/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                  style: TextStyle(fontWeight:FontWeight.bold,fontFamily: 'Varela', color: Colors.black45 , fontSize: 20),
                                  children: [
                                    TextSpan(text: ' Developed By '),
                                    TextSpan(
                                        text: ' Eng ',
                                        style: TextStyle(
                                            color: Colors.orangeAccent,
                                            fontStyle: FontStyle.italic)),
                                    TextSpan(text: ' Shema '),
                                  ]),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            )),
                      );
                    });
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.transparent,
            ),
            onPressed: () {},
          ),
          elevation: 0.0,
          centerTitle: true,
          title: Text('Daily Notes', style: TextStyle(fontFamily: 'Varela')),
        ),
        body: getNoteListView(),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add a note.',
          onPressed: () {
            navigateToDetail(Note('', '', 2), 'Add Note');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              onTap: () {
                navigateToDetail(this.noteList[position], 'Edit Note');
              },
              trailing: GestureDetector(
                onTap: () {
                  _delete(context, noteList[position]);
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
              title: Text(this.noteList[position].title,
                  style: TextStyle(fontFamily: 'Varela')),
              subtitle: Text(this.noteList[position].date,
                  style: TextStyle(fontFamily: 'Varela')),
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
            ),
          );
        });
  }

  // Helper Functions Section .
  //navigation function .
  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetails(note, title)));
    if (result == true) {
      updateListView();
    }
  }

  //priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.orangeAccent;
        break;
      case 2:
        return Colors.brown;
        break;
      default:
        return Colors.brown;
    }
  }

  //icon priority
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(
          Icons.play_arrow,
          color: Colors.white,
        );
      case 2:
        return Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
        );
      default:
        return Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
        );
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontFamily: 'Varela'),
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((notelist) {
        setState(() {
          this.noteList = notelist;
          this.count = notelist.length;
        });
      });
    });
  }
}
