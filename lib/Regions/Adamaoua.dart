import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_android/AppWidget.dart';


class Adamaoua extends StatefulWidget {
  const Adamaoua({super.key});

  @override
  State<Adamaoua> createState() => _AdamaouaState();
}

class _AdamaouaState extends State<Adamaoua> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: AppWidget.themeappbar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppWidget.textetirelistedetick("Liste des destination : Adamaoua"),
            ),
           Padding(
             padding: const EdgeInsets.all(20),
             child: Container(
               width: double.infinity, height: 100,
               decoration: BoxDecoration(
                 color: Colors.blue[100],
                 borderRadius: BorderRadius.circular(10),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.9),
                     spreadRadius: 2,
                     blurRadius: 5,
                     offset: const Offset(0, 3),
                   ),
                 ],
               ),
               child: Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text("De :")
                     ],
                   ),
                 ],
               ),
             ),
           )
          ],
        ),
      ),
    );
  }
}
