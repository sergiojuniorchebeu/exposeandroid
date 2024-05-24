import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_android/AppWidget.dart';
import 'package:project_android/Home%20Page.dart';
import 'package:project_android/Inscription.dart';

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

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _login.text;
      final String password = _password.text;

      if (email.isEmpty || password.isEmpty) {
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
      setState(() {
        _isLoading = true;
      });

      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
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
      setState(() {
        _isLoading = false;
      });
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
