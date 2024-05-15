import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_android/AppWidget.dart';
import 'package:project_android/Drawer/Profile.dart';
import 'package:project_android/Regions/Adamaoua.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    User? _currentUser = _auth.currentUser;
    Color green = Color(0xFF138675);
    Color greenligth = Color(0xFF499D95);
    Color orange = Color(0xFFff7259);
    String? _selecteditem;
    List<String> _menuitem = [
      "Adamaoua",
      "Centre",
      "Est",
      "Ex Nord",
      "Littoral",
      "Nord",
      "Nord-Ouest",
      "Ouest",
      "Sud-Ouest",
      "Sud"
    ];

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
        radius: 20,
      );
    } else {
      profileIcon = const Icon(
        Icons.person,
        size: 40,
      );
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: AppWidget.themeappbar(),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff28c6ff), Color(0xff86e0a0)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(message, style: AppWidget.styledelabel2()),
                    profileIcon
                  ]),
            ),
            GestureDetector(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>const Profile())),
              child: AppWidget.menu(
                  "Profile",
                  const Icon(
                    Icons.person,
                    color: Colors.black,
                  )),
            ),
            GestureDetector(
              child: AppWidget.menu(
                  "Historique",
                  const Icon(
                    Icons.list_alt_outlined,
                    color: Colors.black,
                  )),
            ),
            GestureDetector(
              child: AppWidget.menu(
                  "Mode sombre",
                  const Icon(
                    Icons.dark_mode,
                    color: Colors.black,
                  )),
            ),
            GestureDetector(
              child: AppWidget.menu(
                  "Se déconecter",
                  const Icon(
                    Icons.logout,
                    color: Colors.black,
                  )),
            ),

          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff28c6ff), Color(0xff86e0a0)],
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 20,
                      left: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              message,
                              style: AppWidget.styledelabel2(),
                            ),
                            profileIcon
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Resever un ticket de voyage",
                          style: AppWidget.styledelabel2(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>const Adamaoua())
                    );
                  },
                  child: AppWidget.region("Adamaoua", "Centre"),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: AppWidget.region("Est", "Ex. Nord"),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: AppWidget.region("Littoral", "Nord"),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: AppWidget.region("Nord-Ouest", "Ouest"),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: AppWidget.region("Sud", "Sud-Ouest"),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
            /*Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Theme(
                    data: ThemeData.dark(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "De",
                                style: AppWidget.styledelabel2(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: _selecteditem,
                                hint: Text(
                                  "Region de départ",
                                  style: AppWidget.styledelabel2(),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selecteditem = newValue;
                                  });
                                },
                                items: _menuitem.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: AppWidget.styledelabel2(),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "À",
                                style: AppWidget.styledelabel2(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: _selecteditem,
                                hint: Text(
                                  "Region de destination",
                                  style: AppWidget.styledelabel2(),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selecteditem = newValue;
                                  });
                                },
                                items: _menuitem.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: AppWidget.styledelabel2(),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
