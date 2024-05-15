import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_android/Home%20Page.dart';
import 'package:project_android/Login.dart';
import 'AppWidget.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final TextEditingController _nomcomplet = TextEditingController();
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _registerWithEmailAndPassword() async {
    try {
      final String nomComplet = _nomcomplet.text.trim();
      final String email = _login.text.trim();
      final String password = _password.text.trim();
      final String confirmPassword = _confirmpassword.text.trim();

      if (nomComplet.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erreur'),
              content: const Text('Veuillez remplir tous les champs.'),
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
        return;
      }

      if (password != confirmPassword) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erreur'),
              content: const Text('Les mots de passe ne correspondent pas.'),
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
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await _firebaseFirestore.collection('users').doc(user.uid).set({
          'nomComplet': nomComplet,
          'email': email,
        });

        // Inscription réussie, vous pouvez effectuer des actions supplémentaires ici

      } else {
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

      setState(() {
        _isLoading = false;
      });

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

  Future<void> _registerWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        final String nomComplet = googleUser.displayName ?? '';
        final String email = googleUser.email ?? '';

        await _firebaseFirestore.collection('users').doc(user.uid).set({
          'nomComplet': nomComplet,
          'email': email,
        });

       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));

      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:const Text('Erreur'),
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

      setState(() {
        _isLoading = false;
      });

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
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient:
              LinearGradient(
                  colors: [Color(0xff28c6ff),
                    Color(0xff86e0a0)]),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 22),
              child: Text(
                "Inscription",
                style: AppWidget.styledetexteacceuil(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
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
                          controller: _nomcomplet,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.check,
                              color: Colors.grey,
                            ),
                            label: Text(
                              "Entrez votre Nom ",
                              style: AppWidget.styledelabel(),
                            ),
                          ),
                        ),
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
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                        TextField(
                          controller: _confirmpassword,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            label: Text(
                              "Confirmez votre mot de passe",
                              style: AppWidget.styledelabel(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50,),
                        GestureDetector(
                          onTap: _registerWithEmailAndPassword,
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                  colors: [Color(0xff28c6ff), Color(0xff86e0a0)]),
                            ),
                            child: Center(
                              child: Text(
                                "Inscription",
                                style: AppWidget.styledetexteacceuil(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>const LoginPage()));
                              },
                              child: Text("Déjà un Compte ? Se Connecter", style: AppWidget.styledelabel(),)),
                        ),
                        const SizedBox(height: 20),
                        Text(
                            "© 2024 Sergiojuniorchebeu",
                            style: AppWidget.stylesoustitre()
                        ),
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
