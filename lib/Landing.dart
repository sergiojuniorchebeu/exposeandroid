import 'package:flutter/material.dart';
import 'package:project_android/AppWidget.dart';
import 'package:project_android/HomePage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                 Container(
                   height: 280,
                   width: 254,
                   decoration:const BoxDecoration(
                     color: Colors.white,
                     shape: BoxShape.circle
                   ),
                   child: Center(
                     child: Image.asset("assets/img/train-ticket.png", height: 190, width: 220,),
                   ),
                 ),
               const SizedBox(height: 10,),
                Text("Train Reserve",
                  style: AppWidget.styledetexteacceuil(),),
                Text(
                  "Le Plaisir de reserver",
                  style: AppWidget.styledetexteacceuil(),
                  textAlign: TextAlign.center,),
                const SizedBox(height: 60,),
                Text(
                    "Reservez vos tickets en toute sécurité",
                  style: AppWidget.styledetextesimplegras(),
                ),
                const SizedBox(height: 90,),
                Container(
                  height: 50,
                  width: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      )
                    ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context)=> HomePage()
                            ));
                      },
                      child: Text("Continuer",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25,), )),
                ),
                const SizedBox(height: 30,),
                Container(
                  child:const  Text("©2024 sergiojuniorchebeu SC/groupe2", textAlign: TextAlign.center,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
