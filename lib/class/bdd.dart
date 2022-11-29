import 'dart:developer';

import 'package:collec_otheque/class/api.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:collec_otheque/test/test.db';

class BDD {
  BDD();

  static void createBdd() async {
    // Init ffi loader if needed.
    sqfliteFfiInit();

    var databasesPath = await getDatabasesPath();

    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase(join(databasesPath, 'demo.db'));
    await db.execute('''
  CREATE TABLE Biblio (
      id INTEGER PRIMARY KEY,
      libelle TEXT
  )
  ''');
    await db.execute('''
  CREATE TABLE Etagere (
      id INTEGER PRIMARY KEY,
      libelle TEXT,
      biblio INTEGER,
      FOREIGN KEY (biblio) REFERENCES Biblio(id)
  )
  ''');
    await db.execute('''
  CREATE TABLE Collection (
      id INTEGER PRIMARY KEY,
      libelle TEXT,
      etagere INTEGER,
      FOREIGN KEY (etagere) REFERENCES Etagere(id)
  )
  ''');
    await db.execute('''
  CREATE TABLE Livre (
      id INTEGER PRIMARY KEY,
      titre TEXT,
      url TEXT,
      collection INTEGER,
      FOREIGN KEY (collection) REFERENCES Collection(id)
  )
  ''');

    await db.insert('Biblio', <String, Object?>{'libelle': 'Ma biblio'});
    await db.insert(
        'Etagere', <String, Object?>{'libelle': 'Mon etagère', 'biblio': 1});
    await db.insert('Collection',
        <String, Object?>{'libelle': 'Mon etagère', 'etagere': 1});
    await db.insert('Livre', <String, Object?>{
      'titre': 'test',
      'url':
          'http://books.google.com/books/content?id=vWxokFDTpy4C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api',
      'collection': 1,
    });

    var result = await db.query('Livre');
    log(result.toString());
    //var result = await db.query('Product');
    //log(result.toString());
    // prints [{id: 1, title: Product 1}, {id: 2, title: Product 1}]
    await db.close();
  }

  static void ajouteLivre(int etagere, int isbn) async {
    API monApi = API();
    monApi.getBookByIsbn(isbn);
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await db.insert('Livre', <String, Object?>{
      'titre': monApi.getTitle(),
      'url': monApi.getImage(isbn),
      'collection': etagere,
    });
  }

  static Future<List<dynamic>> recupLivre(int etagere) async {
    API monApi = API();
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory
        .openDatabase("package:collec_otheque/test/test.db");
    var lesLivres =
        await db.query('Livre', where: 'etagere = ' + etagere.toString());
    return lesLivres;
  }
}
