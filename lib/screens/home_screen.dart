import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:notes_keeper_app/helpers/constants.dart';
import 'package:notes_keeper_app/screens/login_screen.dart';
import 'package:notes_keeper_app/screens/view_note.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('notes');

  DocumentReference userDataRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid);

  List<Color> myColors = [
    Colors.yellow[200],
    Colors.red[200],
    Colors.green[200],
    Colors.deepPurple[200],
    Colors.purple[200],
    Colors.cyan[200],
    Colors.teal[200],
    Colors.tealAccent[200],
    Colors.pink[200],
  ];

  Stream<QuerySnapshot> data;
  Stream<DocumentSnapshot> userData;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isHighToLow = true;

  @override
  void initState() {
    setState(() {
      data = ref.snapshots();
      userData = userDataRef.snapshots();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
      ),
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Drawer(
            child: StreamBuilder<DocumentSnapshot>(
                stream: userData,
                builder: (context, AsyncSnapshot<DocumentSnapshot> ss) {
                  var data = ss.data;
                  if (ss.hasData) {
                    if (ss.data != null) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 60.0,
                            ),
                            Container(
                              height: 70.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    data['photoUrl'],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Text(
                              "${data['name']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 16.0,
                                fontFamily: 'Mali',
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "${data['email']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mali',
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 0.2,
                            ),
                            ListTile(
                              onTap: showConfirmationDialog,
                              leading: Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Logout",
                                style: TextStyle(
                                  fontFamily: 'Mali',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: "Mali",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff070706),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: data,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> ss) {
            if (ss.hasError) {
              print(ss.error);
            }
            if (ss.hasData) {
              if (ss.data.docs.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/cover.png',
                        height: 200.0,
                        width: 200.0,
                      ),
                      Text(
                        "You have no saved Notes !",
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Mali',
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                List<QueryDocumentSnapshot> finalData = ss.data.docs;
                if (isHighToLow) {
                  for (int i = 0; i < finalData.length; i++) {
                    for (int j = 0; j < finalData.length; j++) {
                      Map m = finalData[i].data();
                      Map n = finalData[j].data();
                      var temp;
                      if (m["priority"] > n["priority"]) {
                        temp = finalData[j];
                        finalData[j] = finalData[i];
                        finalData[i] = temp;
                      }
                    }
                  }
                } else {
                  for (int i = 0; i < finalData.length; i++) {
                    for (int j = 0; j < finalData.length; j++) {
                      Map m = finalData[i].data();
                      Map n = finalData[j].data();
                      var temp;
                      if (m["priority"] < n["priority"]) {
                        temp = finalData[j];
                        finalData[j] = finalData[i];
                        finalData[i] = temp;
                      }
                    }
                  }
                }

                return Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.grey.shade900,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isHighToLow = true;
                            });
                          },
                          child: Text("High to Low"),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white70,
                            backgroundColor: isHighToLow
                                ? Colors.grey.shade800.withOpacity(0.6)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isHighToLow = false;
                            });
                          },
                          child: Text("Low to High"),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white70,
                            backgroundColor: isHighToLow
                                ? Colors.transparent
                                : Colors.grey.shade800.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: finalData.length,
                        itemBuilder: (context, index) {
                          Map data = finalData[index].data();
                          DateTime myDateTime = data['created'].toDate();
                          String formattedTime =
                              DateFormat.yMMMd().add_jm().format(myDateTime);

                          return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => ViewNoteScreen(
                                      data,
                                      formattedTime,
                                      finalData[index].reference),
                                ),
                              )
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Card(
                                color: Colors.white,
                                borderOnForeground: true,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 9,
                                            child: Text(
                                              "${data['title']}",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: "Mali",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 20.0,
                                              width: 20.0,
                                              decoration: BoxDecoration(
                                                color: data['priority'] == 0
                                                    ? Colors.tealAccent
                                                    : data['priority'] == 1
                                                        ? Colors.amberAccent
                                                        : Colors.redAccent,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          formattedTime,
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontFamily: "Mali",
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  showConfirmationDialog() async {
    //log out from firebase
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Are you sure ?",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Mali',
              ),
            ),
            content: Text(
              "Do you really want to logout...!",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Mali',
              ),
            ),
            actions: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  onSurface: Colors.black,
                  primary: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "No",
                  style: TextStyle(
                    fontFamily: "Mali",
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  elevation: 0.0,
                ),
                onPressed: logOutUser,
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontFamily: "Mali",
                  ),
                ),
              ),
            ],
          );
        });
  }

  logOutUser() async {
    try {
      //log out from firebase
      await FirebaseAuth.instance.signOut();
      //log out from google
      GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.signOut();

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Signed out Successfully",
        style: kSnackBarTextStyle,
      )));
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          "Singed out Failed",
          style: kSnackBarTextStyle,
        )),
      );
    }
  }
}
