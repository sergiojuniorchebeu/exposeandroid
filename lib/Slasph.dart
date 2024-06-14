import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'Admin /Amin homepage.dart';
import 'Agent/Agent Home Page.dart';
import 'AppWidget.dart';
import 'Home Page.dart';
import 'Login.dart';
class Load extends StatefulWidget {
  const Load({super.key});

  @override
  State<Load> createState() => _LoadState();
}

class _LoadState extends State<Load> {

  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      checkLoggedInState(context);
    });
  }

  Future<void> checkLoggedInState(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
          String role = userDoc['role'];

          if (role == 'admin') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()),
                  (route) => false,
            );
          } else if (role == 'user') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          } else if (role == 'agent') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeAgentPage()),
                  (route) => false,
            );
          } else {
            // Si le rôle n'est pas reconnu, redirigez vers la page de connexion
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
            );
          }
        } catch (e) {
          // En cas d'erreur, redirigez vers la page de connexion
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
          );
        }
      } else {
        // Si l'utilisateur actuel est null, redirigez vers la page de connexion
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
        );
      }
    } else {
      // Si l'utilisateur n'est pas connecté, redirigez vers la page de connexion
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[100],
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bienvenue", style: AppWidget.styledetexte(taille: 20, couleur: Colors.black87)),
                const SizedBox(height: 20,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage("assets/img/former.png",),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                AppWidget.loading(Colors.green),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        )
    );
  }
}
