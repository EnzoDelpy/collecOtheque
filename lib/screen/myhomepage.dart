import 'dart:developer';

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
  List<int> _lesIsbn = [9781781101056, 9781781101032, 9782070584642];
  List<Widget> _lesLivres = [];
  bool getData = false;

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
  }

  void buildBookList() async {
    _lesLivres = [];
    if (_lesIsbn.isNotEmpty) {
      for (int k = 0; k < _lesIsbn.length; k++) {
        if (k + 1 == _lesIsbn.length && (k % 2) == 0) {
          _lesLivres.add(
              Row(children: [buildBook(await monApi.getImage(_lesIsbn[k]))]));
        } else if (k % 2 == 0) {
          _lesLivres.add(Row(children: [
            buildBook(await monApi.getImage(_lesIsbn[k])),
            buildBook(await monApi.getImage(_lesIsbn[k + 1]))
          ]));
        }
      }
    }
    log(_lesLivres.toString());
    setState(() {
      _lesLivres;
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
        child: Column(children: _lesLivres),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
