import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_android/Inscription.dart';
import 'package:project_android/Login.dart';
import 'AppWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Home Page.dart';


class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  Future<void> _googleLogIn() async {

    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Connexion", style: AppWidget.styledelabel2(),),
              content: Row(
                children: [
                  AppWidget.loading(Colors.green),
                  const SizedBox(width: 7,),
                  const  Text(
                    "Veuillez patientez...",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                ],
              ),
            );
          },
        );

        await _firebaseAuth.signInWithCredential(credential);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text("Quelque chose s'est mal passé"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff28c6ff),
              Color(0xff86e0a0)
            ]
          )
        ),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Image.asset("assets/img/former.png", width: 160,)),
            const SizedBox(height: 30,),
            Text("Bienvenue", style: AppWidget.styledetexteacceuil(),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>const LoginPage()));
              },
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: Text("Se Connecter", style: AppWidget.styledelabel(),),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>const Inscription()));
              },
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(), borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: Text("S'inscrire", style: AppWidget.styledelabel2()),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                _googleLogIn();
              },
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                    border: Border.all(), borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/img/google.png",
                      width: 40,
                    ),
                    const SizedBox(width: 5,),
                    Text("Continuer avec Google", style: AppWidget.styledelabel(),),

                  ],
                )
              ),
            ),


            const Spacer(),
            Text(
                "© 2024 Sergiojuniorchebeu",
                style: AppWidget.stylesoustitre()
            ),
          ],
        ),
      )
    );
  }
}
