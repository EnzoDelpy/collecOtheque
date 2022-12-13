import 'dart:developer';

import 'package:collec_otheque/class/api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:collec_otheque/test/test.db';

class BDD {
  BDD();

  static Future<void> createBdd() async {
    // Init ffi loader if needed.
    sqfliteFfiInit();

    var databasesPath = await getApplicationDocumentsDirectory();

    var databaseFactory = databaseFactoryFfi;
    var db =
        await databaseFactory.openDatabase(join(databasesPath.path, 'test'));
    await db.execute('''
  CREATE TABLE IF NOT EXISTS Biblio  (
      id INTEGER PRIMARY KEY,
      libelle TEXT
  )
  ''');
    await db.execute('''
  CREATE TABLE IF NOT EXISTS Etagere (
      id INTEGER PRIMARY KEY,
      libelle TEXT,
      biblio INTEGER,
      FOREIGN KEY (biblio) REFERENCES Biblio(id)
  )
  ''');
    await db.execute('''
  CREATE TABLE IF NOT EXISTS Collection (
      id INTEGER PRIMARY KEY,
      libelle TEXT,
      etagere INTEGER,
      FOREIGN KEY (etagere) REFERENCES Etagere(id)
  )
  ''');
    await db.execute('''
  CREATE TABLE IF NOT EXISTS Livre (
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
        <String, Object?>{'libelle': 'Ma collection', 'etagere': 1});
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

  static Future<List<dynamic>> recupLivre(int collection) async {
    var databasesPath = await getApplicationDocumentsDirectory();
    var databaseFactory = databaseFactoryFfi;
    var db =
        await databaseFactory.openDatabase(join(databasesPath.path, 'test'));
    var lesLivres =
        await db.query('Livre', where: 'collection = ' + collection.toString());
    return lesLivres;
  }

  static Future<List<dynamic>> recupBiblio() async {
    var databasesPath = await getApplicationDocumentsDirectory();
    var databaseFactory = databaseFactoryFfi;
    var db =
        await databaseFactory.openDatabase(join(databasesPath.path, 'test'));
    var lesLivres = await db.query('Biblio');
    return lesLivres;
  }

  static Future<List<dynamic>> recupEtagere(int biblio) async {
    var databasesPath = await getApplicationDocumentsDirectory();
    var databaseFactory = databaseFactoryFfi;
    var db =
        await databaseFactory.openDatabase(join(databasesPath.path, 'test'));
    var lesLivres =
        await db.query('Etagere', where: 'biblio = ' + biblio.toString());
    return lesLivres;
  }

  static Future<List<dynamic>> recupCollection(int biblio) async {
    var databasesPath = await getApplicationDocumentsDirectory();
    var databaseFactory = databaseFactoryFfi;
    var db =
        await databaseFactory.openDatabase(join(databasesPath.path, 'test'));
    var lesLivres =
        await db.query('Collection', where: 'etagere = ' + biblio.toString());
    return lesLivres;
  }
}
