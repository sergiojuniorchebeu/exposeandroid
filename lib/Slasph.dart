import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_android/AppWidget.dart';
import 'package:project_android/Intro.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  Future.delayed(Duration(seconds: 5), (){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Intro()));
  });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: double.infinity,
        decoration:const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff28c6ff),
                  Color(0xff86e0a0)
                ], begin: Alignment.topRight,
                end: Alignment.bottomLeft,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: (){},
              icon: Image.asset("assets/img/former.png",width: 120,),
            ),
            const SizedBox(height: 10,),
            Text("Train Ticketing", style: AppWidget.stylebienvenue(),)
          ],
        ),
      ),
    );
  }
}
