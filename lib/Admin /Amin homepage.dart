import 'package:flutter/material.dart';
import 'package:project_android/AppWidget.dart';
import '../Agent/train manage.dart';
import '../Login.dart';
import 'Resavation manage.dart';
import 'Train manage.dart';
import 'User Manage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Se déconnecter'),
                ),
              ),
            ],
          ),
        ],
        centerTitle: true,
        flexibleSpace: AppWidget.themeappbar(),
        title: Text(
          "Tableau de Bord Administrateur",
          style: AppWidget.styledetexte(
            w: FontWeight.w700,
            taille: 18,
            couleur: Colors.black87,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Utilisateurs"),
            Tab(text: "Réservations"),
            Tab(text: "Trains"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UsersManagement(),
          const ReservationsManagement(),
          const TrainsManagement(),
        ],
      ),
    );
  }
}
