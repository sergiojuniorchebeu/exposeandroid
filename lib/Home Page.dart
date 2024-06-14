import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_android/AppWidget.dart';
import 'package:project_android/Drawer/Profile.dart';
import 'package:project_android/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Liste train.dart';
import 'historique.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FontWeight bold = FontWeight.bold;
  final List<String> regions = [
    'Adamaoua', 'Centre', 'Est', 'Extrême-Nord', 'Littoral',
    'Nord', 'Nord-Ouest', 'Ouest', 'Sud', 'Sud-Ouest'
  ];

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    String message = "";
    if (currentUser != null) {
      if (currentUser.displayName != null) {
        message += currentUser.displayName!;
      } else {
        message += currentUser.email!;
      }
    }
    Widget profileIcon;
    if (currentUser != null && currentUser.photoURL != null) {
      profileIcon = CircleAvatar(
        backgroundImage: NetworkImage(currentUser.photoURL!),
      );
    } else {
      profileIcon = const Icon(
        Icons.person,
        color: Colors.black,
        size: 40,
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(padding: const EdgeInsets.all(5),
          child: profileIcon,
          )
        ],
        centerTitle: true,
        title: Text("Bienvenue", style: AppWidget.styledetexte(w: bold, taille: 17),),
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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile())),
              child: AppWidget.menu(
                  "Profile",
                  const Icon(
                    Icons.person,
                    color: Colors.black,
                  )),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReservationHistoryPage()),
                );
              },
              child: AppWidget.menu(
                  "Historique",
                  const Icon(
                    Icons.list_alt_outlined,
                    color: Colors.black,
                  )),
            ),
            GestureDetector(
              child: AppWidget.menu(
                  "Contacter l'assitance",
                  const Icon(
                    Icons.call,
                    color: Colors.black,
                  )),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  bool? shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Se déconnecter'),
                        content: const Text('Voulez-vous vous déconnecter ?'),
                        actions: [
                          TextButton(
                            child: const Text('Non'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Oui'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldLogout ?? false) {
                    await FirebaseAuth.instance.signOut();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false,
                    );
                  }
                } catch (e) {
                  print("Error signing out: $e");
                }
              },
              child: AppWidget.menu(
                "Se déconecter",
                const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: regions.length,
          itemBuilder: (context, index) {
            String region = regions[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegionTrainsPage(region: region),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Color(0xff28c6ff), Color(0xff86e0a0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      region,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ),
    );
  }
}
