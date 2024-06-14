import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_android/Agent/Agent%20Home%20Page.dart';
import 'package:project_android/AppWidget.dart';
import 'package:project_android/Home%20Page.dart';
import 'package:project_android/Inscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Admin /Amin homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isPasswordVisible = false;
  bool _isLoading = false;



  Future<void> _googleLogIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Show a Scaffold Messenger with the message "Connecting..." while loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection...'),
          duration: Duration(seconds: 3),
        ),
      );

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        // Save the login state in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      }
    } catch (e) {
      _showErrorDialog("Error", "Something went wrong: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _login.text.trim();
      final String password = _password.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _showErrorDialog('Error', 'Please fill in all fields.');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection...'),
          duration: Duration(seconds: 5),
        ),
      );

      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
      String role = userDoc['role'];

      if (role == 'admin') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomePage()),
              (route) => false,
        );
      } else if (role == 'user') {
        // Save the login state in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      }else if (role == 'agent'){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeAgentPage()),
              (route) => false,
        );
      }
    }
    catch (e) {
      _showErrorDialog('Erreur', "Quelque chose s'est mal passé: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff28c6ff), Color(0xff86e0a0)]),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 22),
            child: Text(
              "Bienvenue\nConnectez vous",
              style: AppWidget.styledetexteacceuil(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40))),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 18.0),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _login,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          label: Text(
                            "Entrez votre email",
                            style: AppWidget.styledelabel(),
                          ),
                        ),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          label: Text(
                            "Mot de passe",
                            style: AppWidget.styledelabel(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Mot de passe oublié ?",
                          style: AppWidget.styledelabel2(),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: _signInWithEmailAndPassword,
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                                colors: [Color(0xff28c6ff), Color(0xff86e0a0)]),
                          ),
                          child: Center(
                            child:  _isLoading
                                ?AppWidget.loading(Colors.greenAccent)
                                : Text(
                              "Connexion",
                              style: AppWidget.styledetexteacceuil(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                          onTap: () {
                           _googleLogIn();
                          },
                          child: Row(
                            children: [
                              Text(
                                "Continuer avec Google",
                                style: AppWidget.styledelabel(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                "assets/img/google.png",
                                width: 30,
                              ),
                            ],
                          )),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Inscription()));
                            },
                            child: Text(
                              "Pas de Compte ? S'inscrire",
                              style: AppWidget.styledelabel(),
                            )),
                      ),
                      const SizedBox(height: 20),
                      Text("© 2024 Sergiojuniorchebeu",
                          style: AppWidget.stylesoustitre()),
                    ]),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
