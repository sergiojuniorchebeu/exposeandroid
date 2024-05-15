import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_android/AppWidget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    User? _currentUser = _auth.currentUser;
    String message = "";
    if (_currentUser != null) {
      if (_currentUser.displayName != null) {
        message += "" + _currentUser.displayName!;
      } else {
        message += "" + _currentUser.email!;
      }
    }
    Widget profileIcon;
    if (_currentUser != null && _currentUser.photoURL != null) {
      profileIcon = CircleAvatar(
        backgroundImage: NetworkImage(_currentUser.photoURL!),
        radius: 60,

      );
    } else {
      profileIcon = const Icon(
        Icons.person,
        size: 60,
      );
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: AppWidget.themeappbar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profileIcon
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, style: AppWidget.styledelabel2(),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
