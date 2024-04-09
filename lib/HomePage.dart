import 'package:flutter/material.dart';
import 'package:project_android/AppWidget.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:  const EdgeInsets.all(20),
        child: Column(
          children: [
           Row(
             children: [
               Image.asset("assets/img/user.png", height: 40, width: 40,),
               const SizedBox(width: 30,),
               Text("Bonjour Chebeu", style: AppWidget.styledename(),),
               SizedBox(width: 20,),
               const Icon(Icons.notifications, color: Colors.white)
             ],
           ),

          ],
        ),
      ),
    );
  }
}
