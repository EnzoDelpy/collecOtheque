import 'dart:developer';

import 'package:collec_otheque/class/bdd.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:collec_otheque/class/api.dart';
import 'package:flutter/material.dart';

class Collection extends StatefulWidget {
  const Collection({super.key, required this.title});
  final String title;

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  int _counter = 0;
  API monApi = API();
  List<dynamic> _LesCollections = [];
  bool getData = false;

  void _incrementCounter() async {
    //BDD.createBdd();
    setState(() {
      _counter++;
    });
  }

  void buildCollectionList(int id) async {
    await BDD.createBdd();
    _LesCollections = await BDD.recupCollection(id);
    setState(() {
      _LesCollections;
    });
  }

  Widget buildCollection(int id) {
    log(_LesCollections.toString());
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          child: Text(_LesCollections[id - 1]['libelle']),
          onPressed: () =>
              {Navigator.pushNamed(context, "/livre", arguments: id)},
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
                _LesCollections.length, (x) => buildCollection(x + 1))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
