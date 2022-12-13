import 'dart:developer';

import 'package:collec_otheque/class/bdd.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:collec_otheque/class/api.dart';
import 'package:flutter/material.dart';

class Etagere extends StatefulWidget {
  const Etagere({super.key, required this.title});
  final String title;

  @override
  State<Etagere> createState() => _EtagereState();
}

class _EtagereState extends State<Etagere> {
  int _counter = 0;
  API monApi = API();
  List<dynamic> _lesEtageres = [];
  bool getData = false;

  void _incrementCounter() async {
    //BDD.createBdd();
    setState(() {
      _counter++;
    });
  }

  void buildCollectionList(int id) async {
    await BDD.createBdd();
    _lesEtageres = await BDD.recupEtagere(id);
    setState(() {
      _lesEtageres;
    });
  }

  Widget buildCollection(int id) {
    log(_lesEtageres.toString());
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          child: Text(_lesEtageres[id - 1]['libelle']),
          onPressed: () =>
              {Navigator.pushNamed(context, "/collection", arguments: id)},
        ));
  }

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments as int;

    if (!getData) {
      buildCollectionList(id);
      getData = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: List.generate(
                _lesEtageres.length, (x) => buildCollection(x + 1))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
