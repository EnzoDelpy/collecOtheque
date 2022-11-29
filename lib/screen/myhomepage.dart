import 'dart:developer';

import 'package:collec_otheque/class/bdd.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:collec_otheque/class/api.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  API monApi = API();
  List<dynamic> _lesLivres = [];
  List<Widget> _lesLivresAffichage = [];
  bool getData = false;

  void _incrementCounter() async {
    BDD.createBdd();
    setState(() {
      _counter++;
    });
  }

  void buildBookList() async {
    BDD.createBdd();
    _lesLivresAffichage = [];
    _lesLivres = await BDD.recupLivre(1);
    if (_lesLivres.isNotEmpty) {
      for (int k = 0; k < _lesLivres.length; k++) {
        if (k + 1 == _lesLivres.length && (k % 2) == 0) {
          _lesLivresAffichage
              .add(Row(children: [buildBook(_lesLivres[k]['url'])]));
        } else if (k % 2 == 0) {
          _lesLivresAffichage.add(Row(children: [
            buildBook(_lesLivres[k]['url']),
            buildBook(_lesLivres[k]['url'])
          ]));
        }
      }
    }
    log(_lesLivres[0]['url']);
    setState(() {
      _lesLivresAffichage;
    });
  }

  Widget buildBook(String url) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width / 2,
      height: (MediaQuery.of(context).size.width / 2) * 1.44594594595,
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!getData) {
      buildBookList();
      getData = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: _lesLivresAffichage),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
