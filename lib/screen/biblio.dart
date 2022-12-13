import 'dart:developer';

import 'package:collec_otheque/class/bdd.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:collec_otheque/class/api.dart';
import 'package:flutter/material.dart';

class Biblio extends StatefulWidget {
  const Biblio({super.key, required this.title});
  final String title;

  @override
  State<Biblio> createState() => _BiblioState();
}

class _BiblioState extends State<Biblio> {
  int _counter = 0;
  API monApi = API();
  List<dynamic> _lesBiblio = [];
  List<Widget> _lesBiblioAffichage = [];
  bool getData = false;

  void _incrementCounter() async {
    //BDD.createBdd();
    buildBiblioList();
    setState(() {
      _counter++;
    });
  }

  void buildBiblioList() async {
    await BDD.createBdd();
    _lesBiblioAffichage = [];
    _lesBiblio = await BDD.recupBiblio();
    setState(() {
      _lesBiblio;
    });
  }

  Widget buildBiblio(int id) {
    log(_lesBiblio.toString());
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          child: Text(_lesBiblio[id - 1]['libelle']),
          onPressed: () =>
              {Navigator.pushNamed(context, "/etagere", arguments: id)},
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (!getData) {
      buildBiblioList();
      getData = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            children:
                List.generate(_lesBiblio.length, (x) => buildBiblio(x + 1))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
