import 'dart:developer';

import 'package:collec_otheque/class/api.dart';
import 'package:collec_otheque/screen/biblio.dart';
import 'package:collec_otheque/screen/collection.dart';
import 'package:collec_otheque/screen/etagere.dart';
import 'package:collec_otheque/screen/livre.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const Biblio(title: 'Mes biblios'),
      routes: <String, WidgetBuilder>{
        '/collection': (BuildContext context) =>
            const Collection(title: "Mes collections"),
        '/livre': (BuildContext context) => const Livre(title: "Mes Livres"),
        '/etagere': (BuildContext context) =>
            const Etagere(title: "Mes Etageres"),
      },
    );
  }
}
