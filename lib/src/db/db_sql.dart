import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'opportunity_5.db');
    print('path: ' + path.toString());
    return await openDatabase(
      path,
      version: 13,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Tarjeta ('
              ' id_tarjeta INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' numero_tarjeta INTEGER,'
              ' codigo_tarjeta INTEGER,'
              ' expiracion_tarjeta TEXT'
              ')',
        );
      },
    );
  }

  //---------------------------------------------------------------------------------------------------

// para acceder:
  //  await DBProvider.db
  //                                             .agregarTarjeta(
  //                                           aca va el numero de tarjeta, el codigo, el texto
  //                                         );

  Future<int> agregarTarjeta(
      int numeroTarjeta, int codigoTarjeta, String fechaExpiracion) async {

    final db = await database;
    int res = 99;
    List verificar = await verificarTarjeta(numeroTarjeta);
    if (verificar.isEmpty) {
      res = await db.rawInsert(
        "INSERT Into Tarjeta (numero_tarjeta, codigo_tarjeta, expiracion_tarjeta) "
            "VALUES ( $numeroTarjeta, $codigoTarjeta, $fechaExpiracion )",
      );
    }

    return res;
  }

  Future<List> verificarTarjeta(int numeroTarjeta) async {
    final db = await database;
    final res = await db.query(
      'Tarjeta',
      where: 'numero_tarjeta = ?',
      whereArgs: [numeroTarjeta],
      limit: 1,
    );
    List list = res;
    return list;
  }

  Future<List> listarTarjetas() async {
    final db = await database;
    final res = await db.query('Tarjeta', orderBy: 'id_tarjeta desc');
    List list = res;
    return list;
  }

  Future<int> eliminarTarjeta(int numeroTarjeta) async {
    final db = await database;
    final res = await db
        .delete('Tarjeta', where: 'numero_tarjeta = ?', whereArgs: [numeroTarjeta]);
    return res;
  }

// Future<int> contar() async {
//   final db = await database;
//   final res = await db.query('Tarjeta');
//   return res.isNotEmpty ? res.length : 0;
// }
}
