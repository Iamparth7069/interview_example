import 'package:eample/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/userContact.dart';

class DBhelper {
  static const String _dbName = 'crud-operation.db';
  static int _dbVersion = 1;

  // table name
  static const String _tableCategory = 'user';
  static const String profile_images = 'profileImages';
  static const String fName = 'fName';
  static const String id = 'id';
  static const String password = 'password';
  static const String lName = 'lName';
  static const String email = 'email';
  static const String mobileNumber = 'contactNumber';
  static const String description = 'designation';

  // ******************************User Contant Add

  static const String _childtable = 'child';
  static const String cid = 'cid';
  static const String sumEmail = 'email';
  static const String name = 'name';
  static const String pass = 'pass';
  static const String uid = 'uid';
  static Database? _database;

  Future<Database?> getDatabase() async {
    if (_database == null) {
      _database = await createDatabase();
    }
    return _database;
  }

  createDatabase() async {
    var path = join(await getDatabasesPath(), _dbName);
    print('database path : $path');
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $_tableCategory ('
            '$id INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$fName TEXT, '
            '$lName TEXT, '
            '$password Text, '
            '$profile_images TEXT, '
            '$email Text,'
            '$mobileNumber Text,'
            '$description Text'
            ')');
        await db.execute('CREATE TABLE $_childtable ('
            '$cid INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$sumEmail Text,'
            '$name Text, '
            '$pass Text,'
            '$uid INTEGER, '
            'FOREIGN KEY ($uid) REFERENCES $_tableCategory($id) ON DELETE CASCADE'
            ')');
      },
    );
  }

  Future<int> insert(User user) async {
    final db = await getDatabase();
    return await db!.insert(_tableCategory, user.toJson());
  }


  Future<bool> isLoginUser(String emails, String pass) async {
    final db = await getDatabase();
    List<Map<String, dynamic>> result = await db!.query('$_tableCategory',
        where: '$email = ? AND $password = ?', whereArgs: [emails, pass]);
    return result.isNotEmpty;
  }

  Future<List<User>> read() async {
    var categoryList = <User>[];
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db!.rawQuery('select * from $_tableCategory');
    categoryList =
        List.generate(maps.length, (index) => User.fromJson(maps[index]));
    return categoryList;
  }
  Future<int> update(User user) async {
    final db = await getDatabase();
    return await db!.update(_tableCategory, user.toJson(),
        where: '${id} = ?', whereArgs: [user.id]);
  }



  updateUserData(Contact userData)async {
    final db = await getDatabase();
    return await db!.update(
        _childtable,
        userData.toJson(),
        where: '${cid} = ? AND ${uid} = ?',
        whereArgs: [userData.id, userData.uid]
    );
  }
  insertSubData(Contact contact) async {
    final db = await getDatabase();
    return await db!.insert(_childtable, contact.toJson());
  }


  Future<List<Contact>> readSubCategory(int getId) async {
    var categoryList = <Contact>[];
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db!.rawQuery('SELECT * FROM $_childtable WHERE $uid = ?', [getId]);
    categoryList = List.generate(maps.length, (index) => Contact.fromJson(maps[index]));
    return categoryList;
  }

  Future<int?> getUserId(String emails, String passwords) async {
    final db = await getDatabase();
    List<Map<String, dynamic>> result = await db!.query('$_tableCategory',
        columns: ['$id'],
        where: '$email = ? AND $password = ?',
        whereArgs: [emails, passwords]);
    if (result.isNotEmpty) {
      return result[0]['$id'] as int;
    } else {
      return null;
    }
  }


  Future<int> delete(int? ids,int? cids) async {
    final db = await getDatabase();
    return await db!.delete(_childtable,where: '$cid = ? AND $cid = ?',whereArgs: [ids,cids]);
  }
}
