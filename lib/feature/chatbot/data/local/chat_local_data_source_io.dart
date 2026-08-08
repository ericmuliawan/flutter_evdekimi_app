import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter_evdekimi_app/feature/chatbot/data/local/chat_local_data_source.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';

class ChatLocalDataSourceImpl implements IChatLocalDataSource {
  ChatLocalDataSourceImpl() {
    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  static const _databaseName = 'evdekimi.db';
  static const _tableName = 'messages';
  static const _version = 3;

  Future<Database> get _database async {
    final path = '${await databaseFactory.getDatabasesPath()}/$_databaseName';
    return databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _version,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        role TEXT NOT NULL,
        text TEXT NOT NULL,
        username TEXT NOT NULL DEFAULT '',
        image_bytes BLOB,
        image_mime_type TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE $_tableName ADD COLUMN username TEXT NOT NULL DEFAULT ''",
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE $_tableName ADD COLUMN image_bytes BLOB",
      );
      await db.execute(
        "ALTER TABLE $_tableName ADD COLUMN image_mime_type TEXT",
      );
    }
  }

  @override
  Future<List<ChatMessage>> getMessages(String username) async {
    final db = await _database;
    final rows = await db.query(
      _tableName,
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'created_at ASC, id ASC',
    );
    return rows.map(_fromDb).toList();
  }

  @override
  Future<ChatMessage> insertMessage(ChatMessage message, String username) async {
    final db = await _database;
    final id = await db.insert(_tableName, _toDb(message, username));
    return message.copyWith(id: id);
  }

  @override
  Future<void> updateMessageText(int id, String text) async {
    final db = await _database;
    await db.update(
      _tableName,
      {'text': text},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> clearMessages(String username) async {
    final db = await _database;
    await db.delete(
      _tableName,
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  Map<String, Object?> _toDb(ChatMessage message, String username) {
    return {
      'role': message.isUser ? 'user' : 'assistant',
      'text': message.text,
      'username': username,
      'image_bytes': message.imageBytes,
      'image_mime_type': message.imageMimeType,
      'created_at':
          (message.createdAt ?? DateTime.now()).millisecondsSinceEpoch,
    };
  }

  ChatMessage _fromDb(Map<String, Object?> row) {
    return ChatMessage(
      id: row['id'] as int,
      role: row['role'] == 'user' ? ChatRole.user : ChatRole.assistant,
      text: row['text'] as String,
      imageBytes: row['image_bytes'] as Uint8List?,
      imageMimeType: row['image_mime_type'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
    );
  }
}
