import 'dart:convert';
import 'dart:typed_data';

import 'package:jni/jni.dart';
import 'package:jni_leveldb/leveldb/java/io/File.dart' as java;
import 'package:jni_leveldb/leveldb/org/iq80/leveldb/DB.dart';
import 'package:jni_leveldb/leveldb/org/iq80/leveldb/Options.dart';
import 'package:jni_leveldb/leveldb/org/iq80/leveldb/impl/Iq80DBFactory.dart';
import 'package:jni_leveldb/leveldb/org/iq80/leveldb/impl/SeekingIteratorAdapter.dart';

class LevelDB {
  final DB _db;

  LevelDB._(this._db);

  static LevelDB open(String path, {bool createIfMissing = true}) {
    final options = Options()..createIfMissing$1(createIfMissing);
    final file = java.File(path.toJString());
    final db = Iq80DBFactory.factory!.open(file, options);
    if (db == null) {
      throw Exception('Failed to open database at $path');
    }
    return LevelDB._(db);
  }

  void put(String key, String value) {
    putBytes(utf8.encode(key), utf8.encode(value));
  }

  void putBytes(Uint8List key, Uint8List value) {
    using((arena) {
      final jKey = JByteArray.from(key)..releasedBy(arena);
      final jValue = JByteArray.from(value)..releasedBy(arena);
      _db.put(jKey, jValue);
    });
  }

  String? get(String key) {
    final value = getBytes(utf8.encode(key));
    if (value == null) {
      return null;
    }
    return utf8.decode(value);
  }

  Uint8List? getBytes(Uint8List key) {
    return using((arena) {
      final jKey = JByteArray.from(key)..releasedBy(arena);
      final value = _db.get(jKey);
      if (value == null) {
        return null;
      }
      final bytes = value.toList();
      value.release();
      return Uint8List.fromList(bytes);
    });
  }

  void delete(String key) {
    deleteBytes(utf8.encode(key));
  }

  void deleteBytes(Uint8List key) {
    using((arena) {
      final jKey = JByteArray.from(key)..releasedBy(arena);
      _db.delete(jKey);
    });
  }

  void close() {
    _db.release();
  }

  Iterable<MapEntry<String, String>> get entries sync* {
    final iterator = _db.iterator()?.as(SeekingIteratorAdapter.type);
    if (iterator == null) return;
    try {
      iterator.seekToFirst();
      while (iterator.hasNext()) {
        final entry = iterator.next();
        if (entry == null) continue;
        
        final keyBytes = entry.getKey();
        final valueBytes = entry.getValue();

        if (keyBytes == null || valueBytes == null) {
            keyBytes?.release();
            valueBytes?.release();
            entry.release();
            continue;
        }
        
        final key = utf8.decode(keyBytes.toList());
        final value = utf8.decode(valueBytes.toList());
        
        keyBytes.release();
        valueBytes.release();
        entry.release();

        yield MapEntry(key, value);
      }
    } finally {
      iterator.release();
    }
  }
}
