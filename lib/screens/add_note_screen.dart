import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_keeper_app/helpers/constants.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  String title = "";
  String description = "";

  bool checked1 = true;
  bool checked2 = false;
  bool checked3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      //
                      OutlinedButton.icon(
                        icon: Icon(Icons.save),
                        label: Text("Save"),
                        style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          onSurface: Colors.white,
                        ),
                        onPressed: save,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Form(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Priority :",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Mali',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            InkWell(
                              child: Tooltip(
                                message: "Low",
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                    color: Colors.tealAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: checked1
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.black,
                                        )
                                      : Container(),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  checked1 = true;
                                  checked2 = false;
                                  checked3 = false;
                                });
                              },
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  checked1 = false;
                                  checked2 = true;
                                  checked3 = false;
                                });
                              },
                              child: Tooltip(
                                message: "Medium",
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                    color: Colors.amberAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: checked2
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.black,
                                        )
                                      : Container(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  checked1 = false;
                                  checked2 = false;
                                  checked3 = true;
                                });
                              },
                              child: Tooltip(
                                message: "High",
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: checked3
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.black,
                                        )
                                      : Container(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Add title",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.white54.withOpacity(0.4),
                            ),
                          ),
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'Mali',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          onChanged: (val) {
                            setState(() {
                              title = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          maxLines: 20,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter description",
                            hintStyle: TextStyle(
                              color: Colors.white54.withOpacity(0.4),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Mali',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          onChanged: (val) {
                            setState(() {
                              description = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('notes');

    if (title == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Add title",
        style: kSnackBarTextStyle,
      )));
    } else if (description == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Add description",
        style: kSnackBarTextStyle,
      )));
    } else {
      int priorityIndex = 0;
      if (checked3 == true) {
        priorityIndex = 2;
      } else if (checked2 == true) {
        priorityIndex = 1;
      } else {
        priorityIndex = 0;
      }

      var data = {
        'title': title,
        'description': description,
        'created': DateTime.now(),
        'priority': priorityIndex,
      };

      ref.add(data);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Saved...",
          style: kSnackBarTextStyle,
        ),
        duration: Duration(milliseconds: 1500),
        action: SnackBarAction(
          label: "👍",
          onPressed: () {},
        ),
      ));
      Navigator.of(context).pop();
    }
  }
}
