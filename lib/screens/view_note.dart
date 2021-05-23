import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_keeper_app/helpers/constants.dart';

class ViewNoteScreen extends StatefulWidget {
  final Map data;
  final String time;
  final DocumentReference ref;

  ViewNoteScreen(this.data, this.time, this.ref);
  @override
  _ViewNoteScreenState createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  String title;
  String des;
  bool checked1;
  bool checked2;
  bool checked3;

  bool edit = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.data['priority'] == 0) {
      checked1 = true;
      checked2 = false;
      checked3 = false;
    } else if (widget.data['priority'] == 1) {
      checked1 = false;
      checked2 = true;
      checked3 = false;
    } else {
      checked1 = false;
      checked2 = false;
      checked3 = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['description'];
    return SafeArea(
      child: Scaffold(
        floatingActionButton: edit
            ? FloatingActionButton(
                onPressed: save,
                child: Icon(
                  Icons.save_rounded,
                  color: Colors.black,
                ),
                //backgroundColor: Colors.grey[700],
                backgroundColor: Colors.white,
              )
            : Container(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        OutlinedButton(
                          onPressed: delete,
                          child: Icon(
                            Icons.delete_forever,
                            size: 24.0,
                            color: Colors.redAccent,
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
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
                        onTap: edit
                            ? () {
                                setState(() {
                                  checked1 = true;
                                  checked2 = false;
                                  checked3 = false;
                                });
                              }
                            : null,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      InkWell(
                        onTap: edit
                            ? () {
                                setState(() {
                                  checked1 = false;
                                  checked2 = true;
                                  checked3 = false;
                                });
                              }
                            : null,
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
                        onTap: edit
                            ? () {
                                setState(() {
                                  checked1 = false;
                                  checked2 = false;
                                  checked3 = true;
                                });
                              }
                            : null,
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
                ),
                Form(
                  key: key,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: "Title",
                          ),
                          style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: "Mali",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          initialValue: widget.data['title'],
                          enabled: edit,
                          maxLines: 2,
                          onChanged: (_val) {
                            title = _val;
                          },
                          validator: (_val) {
                            if (_val.isEmpty) {
                              return "Can't be empty !";
                            } else {
                              return null;
                            }
                          },
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12.0,
                            bottom: 12.0,
                          ),
                          child: Text(
                            widget.time,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Mali",
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: "Note Description",
                          ),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Mali",
                            color: Colors.grey,
                          ),
                          initialValue: widget.data['description'],
                          enabled: edit,
                          onChanged: (_val) {
                            des = _val;
                          },
                          maxLines: 18,
                          validator: (_val) {
                            if (_val.isEmpty) {
                              return "Can't be empty !";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void delete() async {
    // delete from db
    try {
      await widget.ref.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Deleted...",
            style: kSnackBarTextStyle,
          ),
          action: SnackBarAction(
            textColor: Colors.black,
            label: "👍",
            onPressed: () {},
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: ${e.toString()}",
            style: kSnackBarTextStyle,
          ),
        ),
      );
    }
  }

  void save() async {
    if (key.currentState.validate()) {
      var priority = checked1 == true
          ? 0
          : checked2 == true
              ? 1
              : 2;
      await widget.ref.update(
        {'title': title, 'description': des, 'priority': priority},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Updated...",
            style: kSnackBarTextStyle,
          ),
          action: SnackBarAction(
            textColor: Colors.black,
            label: "👍",
            onPressed: () {},
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
