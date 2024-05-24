import 'package:flutter/material.dart';


class AppWidget {
  static TextStyle styledetexteacceuil() {
    return const TextStyle(
        color: Color(0xff185152), fontSize: 25, fontWeight: FontWeight.bold);
  }

  static TextStyle styledetextesimplegras() {
    return const TextStyle(
        color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);
  }

  static TextStyle styledename() {
    return const TextStyle(
        color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold);
  }

  static TextStyle stylesoustitre() {
    return TextStyle(
      fontFamily: "Poppins",
      fontSize: 12,
      color: Colors.grey[600],
    );
  }

  static TextStyle styledelabel() {
    return const TextStyle(
      fontFamily: "Poppins",
      fontWeight: FontWeight.bold,
      color: Color(0xff185152),
    );
  } static TextStyle styledelab() {
    return const TextStyle(
      fontFamily: "Poppins",
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }
  static TextStyle styledelabel2() {
    return const TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.bold,
        color: Color(0xff185152),
        fontSize: 17
    );

  }

  static TextStyle stylebienvenue() {
    return const TextStyle(
      fontFamily: "Poppins",
      fontWeight: FontWeight.bold,
      color: Color(0xff185152),
      fontSize: 20
    );
  }

  static ListTile menu(String titre, Icon icone){
    return ListTile(
      title: Text(titre, style:styledelabel2(),),
      leading: icone,
    );
  }

  static Row region (String region, region2){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 150, height: 100,
            decoration: BoxDecoration(
               color: const Color(0xff28c6ff),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child:Center(child: Text(region, style: styledelabel2(),))
        ),
        const SizedBox(width: 10),
        Container(
            width: 150, height: 100,
            decoration: BoxDecoration(
              color: const Color(0xff86e0a0),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child:Center(child: Text(region2, style: styledelabel2(),))
        ),
      ],
    );
  }

  static Container themeappbar(){
    return  Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff28c6ff), Color(0xff86e0a0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
    );
  }

  static ListTile listileavecicone(Icon icone, String titre, soustitre){
    return ListTile(
      leading: icone,
      title: Text(titre, style: styledelabel2(),),
      subtitle: Text(soustitre, style: stylesoustitre(),),
    );
  }

  static Padding listemenuprofile(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration:const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xff28c6ff),
              Color(0xff86e0a0)
            ],
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              child: listileavecicone(const Icon(Icons.edit), "Modifier le mot de passe", ""),
            )
          ],
        ),
      ),
    );
  }

  static Center textetirelistedetick(String titre){
    return Center(
      child: Text(titre, style: styledelabel2(),),
    );
  }

  static CircularProgressIndicator loading(Color couleur){
    return CircularProgressIndicator(
      color: couleur,
    );
  }

}
