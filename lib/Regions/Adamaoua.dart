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
    );
  }
}
