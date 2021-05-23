import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_keeper_app/helpers/constants.dart';
import 'package:notes_keeper_app/screens/home_screen.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore fireStore = FirebaseFirestore.instance;
CollectionReference users = fireStore.collection('users');

signInWithGoogle(BuildContext context) async {
  //here context is passed so that we can show snack bar to the user
  try {
    //prompt to sign-in (Dialog)
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User user = authResult.user;
      // user = information about google user provided by google itself
      var userData = {
        'name': user.displayName,
        'provider': 'google',
        'photoUrl': user.photoURL,
        'email': user.email,
      };

      users.doc(user.uid).get().then((DocumentSnapshot doc) {
        if (doc.exists) {
          //old user
          //doc.reference.update(userData);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Welcome back... ${user.displayName}",
            style: kSnackBarTextStyle,
          )));
        } else {
          //new user
          //users.add method will add new document with auto generated unique id
          //user.doc(specify your own id here).set
          users.doc(user.uid).set(userData);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Welcome... ${user.displayName}",
            style: kSnackBarTextStyle,
          )));
        }
      });

      return true;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      "ERROR : ${e.toString()}",
      style: kSnackBarTextStyle,
    )));
  }

  // Obtain the auth details from the request

  // Create a new credential

  // Once signed in, return the UserCredential
}
