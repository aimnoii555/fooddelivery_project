import 'package:fooddelivery_project/model/cart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

// creating database table
  _onCreate(Database db, int version) async {
    await db.execute(
        'create table cart (id integer primary key, idRes text, idCus text, restaurantName text,idFood text, foodName text, foodPrice integer, amount integer, sum integer, distance text, menuFood text, image text, transport text)');
  }

// inserting data into the table
  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;
    await dbClient!.insert('cart', cart.toJson());
    return cart;
  }

// getting all the items in the list from the database
  Future<List<Cart>> getCartList(String idCus) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cart',where: 'idCus = ?', whereArgs: [idCus]);
    return queryResult.map((result) => Cart.fromJson(result)).toList();
  }

  Future<int> updateAmount(Cart cart) async {
    var dbClient = await database;
    return await dbClient!
        .update('cart', cart.toJson(), where: 'id = ?', whereArgs: [cart.id]);
  }

// deleting an item from the cart screen
  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllCart() async {
    var dbClient = await database;
    return await dbClient!.delete('cart');
  }
}
