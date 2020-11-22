import 'dart:async';
import 'dart:io';

import 'package:emp_recog_plat/features/notifications/data/model/notification_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static final _DATABASE_NAME = 'emg_recog_plat.db';
  static final _DATABASE_VERSION = 1;

  static final _LEADERBOARD_TABLE_NAME = 'leaderboard_table';
  static final _LEADERBOARD_TABLE_COLUMN_TYPE = 'type';
  static final _LEADERBOARD_TABLE_COLUMN_RANK = 'rank';
  static final _LEADERBOARD_TABLE_COLUMN_NAME = 'name';
  static final _LEADERBOARD_TABLE_COLUMN_CHEERS = 'cheers';
  static final _LEADERBOARD_TABLE_COLUMN_IMAGE_URL = 'imageURL';

  static final _NOTIFICATION_TABLE_NAME = 'notification_table';
  static final _NOTIFICATION_TABLE_COLUMN_ID = 'id';
  static final _NOTIFICATION_TABLE_COLUMN_TITLE = 'title';
  static final _NOTIFICATION_TABLE_COLUMN_MESSAGE = 'message';
  static final _NOTIFICATION_TABLE_COLUMN_TIMESTAMP = 'timestamp';

  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }

    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _DATABASE_NAME);
    return await openDatabase(path,
        version: _DATABASE_VERSION, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_NOTIFICATION_TABLE_NAME (
        $_NOTIFICATION_TABLE_COLUMN_ID TEXT PRIMARY KEY,
        $_NOTIFICATION_TABLE_COLUMN_TITLE TEXT,
        $_NOTIFICATION_TABLE_COLUMN_MESSAGE TEXT,
        $_NOTIFICATION_TABLE_COLUMN_TIMESTAMP TEXT
      )
    ''');
  }

  Future<int> insertNotification(NotificationModel notif) async {
    final db = await database;

    return await db.rawInsert('''
      INSERT INTO $_NOTIFICATION_TABLE_NAME (
        $_NOTIFICATION_TABLE_COLUMN_ID, 
        $_NOTIFICATION_TABLE_COLUMN_TITLE,
        $_NOTIFICATION_TABLE_COLUMN_MESSAGE,
        $_NOTIFICATION_TABLE_COLUMN_TIMESTAMP
      ) VALUES (?, ?, ?, ?)
    ''', [notif.id, notif.title, notif.message, notif.timestamp.millisecondsSinceEpoch.toString()]);
  }

  Future<List<NotificationModel>> getNotifications() async {
    final db = await database;

    var res = await db.query(_NOTIFICATION_TABLE_NAME);
    if(res.isEmpty) {
      return [];
    } else {
      print(res);

      return [];
    }
  }
}
