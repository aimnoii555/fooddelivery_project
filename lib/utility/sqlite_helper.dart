import 'package:fooddelivery_project/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'fooddelivery.db';
  final String table = 'cart';
  int version = 1;

  final String id = 'id';
  final String idChef = 'idChef';
  final String nameChef = 'nameChef';
  final String idFood = 'idFood';
  final String nameFood = 'nameFood';
  final String price = 'price';
  final String amount = 'amount';
  final String sum = 'sum';
  final String distance = 'distance';
  final String transport = 'transport';

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'create table cart ($id integer primary key, $idChef text, $nameChef text,$idFood text, $nameFood text, $price text, $amount text, $sum text, $distance text, $transport text)'),
      version: version,
    );
  }

  Future<Database> connectedDatabase() async {
    return openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertData(CartModel cartModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        table,
        cartModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('e insertData == ${e.toString()}');
    }
  }

  Future<List<CartModel>> readAllCart() async {
    Database database = await connectedDatabase();
    List<CartModel> cartModels = [];

    List<Map<String, dynamic>> maps = await database.query(table);
    for (var map in maps) {
      CartModel cartModel = CartModel.fromJson(map);
      cartModels.add(cartModel);
    }

    return cartModels;
  }

  Future<Null> deleteFoodCart(int idFood) async {
    Database database = await connectedDatabase();
    try {
      await database.delete(table, where: '$id = $idFood');
    } catch (e) {
      print('delete = ${e.toString()}');
    }
  }

  Future<Null> deleteAllCart() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(table);
    } catch (e) {
      print('delete all = ${e.toString()}');
    }
  }
}
