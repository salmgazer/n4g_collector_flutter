import '../models/country.dart';
import '../models/models.dart';
import '../models/wallet-top-up.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import '../models/supplier.dart';
import '../models/community.dart';
import '../models/organization.dart';
import '../models/product.dart';
import '../models/currency.dart';
import '../models/language.dart';
import '../models/withdrawal.dart';
import '../models/trade.dart';
import '../models/app_settings.dart';
import 'package:sqflite_migration/sqflite_migration.dart';


import '../db/migrations/initial.dart';
import '../db/migrations/migration_0001.dart';

class AppDb {
  static Database db;


  static const models = {
    "suppliers": Supplier
  };

  static open() async {
    var databasesPath = await getDatabasesPath();
    final dbConfig = MigrationConfig(
        initializationScript: initialScript,
        migrationScripts: migration_0001); // put migration scripts in this array
    var path = join(databasesPath, "wowzee.db");

    try {
      await Directory(databasesPath).create(recursive: true);
      db = await openDatabaseWithMigration(path, dbConfig);
    } catch (e) {
      print("Error $e");
    }

    if (db == null) {
      // Should happen only the first time you launch your application
      print("Supposed to create new copy from asset");


      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "wowzee.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);

      // open the database
      // db = await openDatabase(path, version: 1);
      db = await openDatabaseWithMigration(path, dbConfig);

    } else {
      print("Opening existing database");
    }
  }

  static initializeDB() async {
    if (AppDb.db == null) {
      print('NO DB connection');
      await AppDb.open();
    } else {

      print('DB Connection already exists');
    }
  }

  static Future<dynamic> createOne(String tableName, Map itemMap) async {
    await initializeDB();
    print(itemMap);
    final itemId = await db.insert(tableName, itemMap);
    print(itemId);
    return itemId;
  }

  static Future<dynamic> batchInsert(String tableName, List<dynamic> itemMaps) async {
    await initializeDB();

    final batch = db.batch();

    if (itemMaps == null) {
      return;
    }
    for (var i = 0; i < itemMaps.length; i++) {
      batch.insert(tableName, itemMaps[i]);
    }

    return  batch.commit(noResult: true, continueOnError: true);
  }

  static Future<dynamic> batchInsertWithError(String tableName, List<dynamic> itemMaps) async {
    await initializeDB();

    final batch = db.batch();

    if (itemMaps == null) {
      return;
    }
    for (var i = 0; i < itemMaps.length; i++) {
      batch.insert(tableName, itemMaps[i]);
    }

    return  batch.commit(noResult: true);
  }

  static Future<dynamic> findOne(
      String tableName, dynamic id, dynamic model) async {
    await initializeDB();
    List<Map> maps =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.length > 0) {
      return model.fromMap(maps.first);
    }

    return null;
  }

  static Future<dynamic> findSupplierById(String id) async {
    await initializeDB();
    List<Map> maps =
    await db.query(Supplier.tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.length > 0) {
      return Supplier.fromMap(maps.first);
    }

    return null;
  }


  static Future<dynamic> filterTransactionsByProductId(productId) async {
    await initializeDB();
    List<Map> transactions = await db.rawQuery(''
        'SELECT transactions.id, transactions.amountPaid, transactions.collectorId, transactions.cost, transactions.createdAt, transactions.currencyId, transactions.date, transactions.payment, transactions.productId, transactions.sacs, transactions.status, transactions.supplierId, transactions.createdAt, transactions.updatedAt,'
        'products.name as produce,'
        'suppliers.firstName as supplierFirstName,'
        'suppliers.otherNames as supplierLastName,'
        'users.firstName as collectorFirstName,'
        'users.otherNames as collectorLastName '
        'from transactions '
        'INNER JOIN products on products.id = transactions.productId '
        'INNER JOIN suppliers on suppliers.id = transactions.supplierId '
        'INNER JOIN users on users.userId = transactions.collectorId '
        'where transactions.productId = ?'
        '', [productId]);
    return transactions.map((item) => Trade.fromMap(item)).toList();
  }

  static Future<dynamic> findCountryByCode(String code) async {
    await initializeDB();
    List<Map> maps =
    await db.query(Country.tableName, where: 'code = ?', whereArgs: [code]);

    if (maps.length > 0) {
      return Country.fromMap(maps.first);
    }

    return null;
  }

  static Future<dynamic> findRegionById(dynamic id) async {
    await initializeDB();
    List<Map> maps =
    await db.query(Region.tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.length > 0) {
      return Region.fromMap(maps.first);
    }

    return null;
  }

  static Future<dynamic> findDistrictById(dynamic id) async {
    await initializeDB();
    List<Map> maps =
    await db.query(District.tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.length > 0) {
      return District.fromMap(maps.first);
    }

    return null;
  }

  static Future<dynamic> findUserById(String userId) async {
    await initializeDB();
    List<Map> maps =
    await db.query(User.tableName, where: 'userId = ?', whereArgs: [userId]);

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }

    return null;
  }

  static Future<dynamic> getAppSetting() async {
    await initializeDB();
    List<Map> maps = await db.query(AppSetting.tableName);
    if (maps.length > 0) {
      print(maps.first);
      return AppSetting.fromMap(maps.first);
    } else {
      await createOne(AppSetting.tableName, <String, dynamic> {
        "currencyName": "Ghanaian cedis",
        "languageCode": "eng",
        "lastLogInDate": null
      });
      maps = await db.query(AppSetting.tableName);
      if (maps.length > 0) {
        print("+++++++++++++++++++++++++");
        print(maps.first);
        return AppSetting.fromMap(maps.first);
      }
    }
    return null;
  }

  static Future<dynamic> filterSuppliers() async {
    await initializeDB();

    List<Map> maps = await db.rawQuery(''
        'SELECT suppliers.id, '
        'suppliers.firstName, '
        'suppliers.otherNames, '
        'suppliers.phone, '
        'suppliers.gender, '
        'suppliers.membershipCode, '
        'suppliers.accountBalance, '
        'suppliers.createdAt, '
        'suppliers.updatedAt ,'
        'communities.name as community '
        'from suppliers '
        'INNER JOIN communities on communities.id = suppliers.communityId'
    );
    return maps.map((item) => Supplier.fromMap(item)).toList();
  }

  static Future<dynamic> filterSupplierWithdrawals(supplierId) async {
    await initializeDB();
    List<Map> withdrawals = await db.rawQuery(''
        'SELECT withdrawals.id, '
        'withdrawals.amount, '
        'withdrawals.collectorId, '
        'withdrawals.reason, '
        'withdrawals.productId, '
        'withdrawals.sacs, '
        'withdrawals.createdAt, '
        'products.name as produce, '
        'users.firstName as collectorFirstName, '
        'users.otherNames as collectorLastName, '
        'withdrawals.updatedAt from withdrawals '
        'INNER JOIN users on users.userId = withdrawals.collectorId '
        'INNER JOIN products on products.id = withdrawals.productId '
        'where supplierId = ?', [supplierId]
    );
    return withdrawals.map((item) => Withdrawal.fromMap(item)).toList();
  }

  /*
  Withdrawal(
    this.id,
    this.amount,
    this.collector,
    this.supplier,
    this.reason,
    this.produceId,
    this.sacs,
    this.produce,
    this.createdAt,
    this.updatedAt
  );
   */
  static Future<dynamic> filterWithdrawals() async {
    print("SALIFU");
    await initializeDB();
    List<Map> withdrawals = await db.rawQuery(''
        'SELECT withdrawals.id, '
        'withdrawals.amount, '
        'withdrawals.collectorId, '
        'withdrawals.reason, '
        'withdrawals.productId, '
        'withdrawals.sacs, '
        'withdrawals.createdAt, '
        'products.name as produce, '
        'users.firstName as collectorFirstName, '
        'users.otherNames as collectorLastName, '
        'withdrawals.updatedAt from withdrawals '
        'INNER JOIN users on users.userId = withdrawals.collectorId '
        'INNER JOIN products on products.id = withdrawals.productId '
    );
    print(withdrawals);
    return withdrawals.map((item) => Withdrawal.fromMap(item)).toList();
  }

  static Future<dynamic> filterWalletTopUps(userId) async {
    await initializeDB();
    List<Map> walletTopUps = await db.rawQuery(''
        'SELECT walletTopUps.id,  walletTopUps.amount, walletTopUps.forUserId, walletTopUps.byUserId, walletTopUps.createdAt, walletTopUps.updatedAt, '
        'users.firstName as byUserFirstName,'
        'users.otherNames as byUserLastName '
        'from walletTopUps '
        'INNER JOIN users on users.id = walletTopUps.byUserId '
        'where forUserId = ?', [userId]);

    return walletTopUps.map((item) => WalletTopUp.fromMap(item)).toList();
  }

  static Future<dynamic> filterSupplierTransactions(supplierId) async {
    await initializeDB();
    List<Map> transactions = await db.rawQuery(''
        'SELECT transactions.id, transactions.amountPaid, transactions.collectorId, transactions.cost, transactions.createdAt, transactions.currencyId, transactions.date, transactions.payment, transactions.productId, transactions.sacs, transactions.status, transactions.supplierId, transactions.createdAt, transactions.updatedAt,'
        'products.name as produce,'
        'suppliers.firstName as supplierFirstName,'
        'suppliers.otherNames as supplierLastName,'
        'users.firstName as collectorFirstName,'
        'users.otherNames as collectorLastName '
        'from transactions '
        'INNER JOIN products on products.id = transactions.productId '
        'INNER JOIN suppliers on suppliers.id = transactions.supplierId '
        'INNER JOIN users on users.userId = transactions.collectorId '
        'where transactions.supplierId = ?'
        '', [supplierId]);
    return transactions.map((item) => Trade.fromMap(item)).toList();
  }


  static Future<dynamic> filterTransactions() async {
    await initializeDB();
    List<Map> transactions = await db.rawQuery(''
        'SELECT transactions.id, transactions.amountPaid, transactions.collectorId, transactions.cost, transactions.createdAt, transactions.currencyId, transactions.date, transactions.payment, transactions.productId, transactions.sacs, transactions.status, transactions.supplierId, transactions.createdAt, transactions.updatedAt,'
        'products.name as produce,'
        'suppliers.firstName as supplierFirstName,'
        'suppliers.otherNames as supplierLastName,'
        'users.firstName as collectorFirstName,'
        'users.otherNames as collectorLastName '
        'from transactions '
        'INNER JOIN products on products.id = transactions.productId '
        'INNER JOIN suppliers on suppliers.id = transactions.supplierId '
        'INNER JOIN users on users.userId = transactions.collectorId');
    return transactions.map((item) => Trade.fromMap(item)).toList();
  }

  static Future<dynamic> filterProducts() async {
    await initializeDB();
    List<Map> maps = await db.query(Product.tableName);
    return maps.map((item) => Product.fromMap(item)).toList();
  }

  static Future<dynamic> filterUsers() async {
    await initializeDB();
    List<Map> maps = await db.query(User.tableName);
    return maps.map((item) => User.fromMap(item)).toList();
  }

  static Future<dynamic> filterOrganizations() async {
    await initializeDB();
    List<Map> maps = await db.query(Organization.tableName);
    return maps.map((item) => Organization.fromMap(item)).toList();
  }

  static Future<dynamic> filterCommunities() async {
    await initializeDB();
    List<Map> maps = await db.query(Community.tableName);
    return maps.map((item) => Community.fromMap(item)).toList();
  }

  static Future<dynamic> filterCurrencies() async {
    await initializeDB();
    List<Map> maps = await db.query(Currency.tableName);
    return maps.map((item) => Currency.fromMap(item)).toList();
  }

  static Future<dynamic> filterLanguages() async {
    await initializeDB();
    List<Map> maps = await db.query(Language.tableName);
    return maps.map((item) => Language.fromMap(item)).toList();
  }

  static Future<dynamic> findUser(String phone, String password) async {
    await initializeDB();

    List<Map> users =
        await db.query('users', where: 'phone = ?', whereArgs: [phone]);
    if (users.length > 0) {
      return User.fromMap(users.first);
    }
    return null;
  }

  static Future<int> delete(String tableName, dynamic id) async {
    await initializeDB();
    return await db.delete(tableName, where: '$id = ?', whereArgs: [id]);
  }

  static Future<int> update(String tableName, Map itemMap) async {
    await initializeDB();
    return await db
        .update(tableName, itemMap, where: 'id = ?', whereArgs: [itemMap['id']]);
  }

  static Future<int> updateTransactionAmountPaid(double newAmount, String transactionId, String payment, int currentTime) async {
    await initializeDB();

    return db.rawUpdate(
        'UPDATE transactions SET "amountPaid" = ?, "updatedAt" = ?, payment = ? WHERE id = ?',
        [newAmount, currentTime, payment, transactionId]);
  }

  static Future<int> updateAppSetting(Map itemMap) async {
    await initializeDB();
    return await db.update(AppSetting.tableName, itemMap);
  }

  static Future<int> updateSupplerAccountBalance(String tableName, String type, String supplierId, double amount) async {

    await initializeDB();
    final supplier = await findSupplierById(supplierId);

    var newAccountBalance;

    if (type == 'add') {
      newAccountBalance = supplier.accountBalance + amount;
    } else {
      newAccountBalance = supplier.accountBalance - amount;
    }
    // Update some record
    int count = await db.rawUpdate(
        'UPDATE suppliers SET accountBalance = ? WHERE id = ?',
        [newAccountBalance, supplierId]);

    return count;
    // return await db.rawUpdate('update table $tableName set accountBalance = $newAccountBalance');
  }

  static Future<int> updateUserWallet(String tableName, String type, String userId, double amount) async {

    await initializeDB();
    final user = await findUserById(userId);

    var newWalletBalance;

    if (type == 'add') {
      newWalletBalance = user.wallet + amount;
    } else {
      newWalletBalance = user.wallet - amount;
    }
    // Update some record
    int count = await db.rawUpdate(
        'UPDATE users SET wallet = ? WHERE id = ?',
        [newWalletBalance, userId]);

    final user1 = await findUserById(userId);

    print("@@@@@@@@@@@@@@@@@@");
    print(userId);
    print(user.userId);
    print(user1.userId);
    print(newWalletBalance);
    print(count);
    print(user1.wallet);
    print("@@@@@@@@@@@@@@@@@@");




    return count;
    // return await db.rawUpdate('update table $tableName set accountBalance = $newAccountBalance');
  }

  static Future close() async => db.close();
}
