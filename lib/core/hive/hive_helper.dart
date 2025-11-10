import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../models/cached_item.dart';
import 'hive_timestamped.dart';

class HiveBoxHelper<T> {
  final String boxName;
  Box<T>? _box;
  Box<CachedItem<T>>? _cachedBox;


  HiveBoxHelper(this.boxName);

  /// Ensures the Hive box is opened (lazily).
  Future<Box<T>> _ensureBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    if (Hive.isBoxOpen(boxName)) {
      _box = Hive.box<T>(boxName);
    } else {
      _box = await Hive.openBox<T>(boxName);
    }
    return _box!;
  }

  Future<Box<CachedItem<T>>> _ensureCachedBox() async {
    if (_cachedBox != null && _cachedBox!.isOpen) return _cachedBox!;
    if (Hive.isBoxOpen(boxName)) {
      _cachedBox = Hive.box<CachedItem<T>>(boxName);
    } else {
      _cachedBox = await Hive.openBox<CachedItem<T>>(boxName);
    }
    return _cachedBox!;
  }

  /// Put a value by key
  Future<void> put(dynamic key, T value) async {
    print('sssssss');
    try
    {
      final box = await _ensureBox();
      // Set createdAt only if it's null
      if (value is HiveTimestamped) {
        value.createdAt ??= DateTime.now();
      }
      await box.put(key, value);
      print('sssss11');
    }catch(e){
        print(e);
    }

  }

  /// Put a value with timestamp (wraps in CachedItem<T>)
  /// Only works if box is Box<CachedItem<T>>
  Future<void> putWithTimestamp<X>(dynamic key, X value) async {
    final box = await _ensureBox(); // This should be Box<T> where T = CachedItem<X>

    final wrapped = CachedItem<X>(
      item: value,
      cachedAt: DateTime.now(),
    );

    // ✅ Safely cast because you already declared T as CachedItem<X>
    await box.put(key, wrapped as T);
  }

  /// Get a value by key
  Future<T?> get(dynamic key) async {
    try{
      final box = await _ensureBox();
      return box.get(key);
    }catch(e){
      print(e);
      return null;
    }


  }

  Future<T?> getByKey(dynamic key) async {
    try {
      final box = await _ensureBox();
      final v = box.get(key);                 //  key-based (String or int)
      return v is T ? v : null;
    } catch (e) {
      debugPrint('Hive getByKey error: $e');
      return null;
    }
  }

  /// Delete a value by key
  Future<void> delete(dynamic key) async {
    final box = await _ensureBox();
    if (box.containsKey(key)) {
      await box.delete(key);
      print('✅ Deleted key "$key" from box "$boxName".');
    } else {
      print('⚠️ Key "$key" not found in box "$boxName".');
    }
  }

  /// Check if a key exists
  Future<bool> containsKey(dynamic key) async {
    final box = await _ensureBox();
    return box.containsKey(key);
  }

  /// Get all values as a list
  Future<List<T>> getAll() async {
    final box = await _ensureBox();
    return box.values.toList();
  }

  /// Get all entries as a map
  Future<Map<dynamic, T>> getAllMap() async {
    final box = await _ensureBox();
    return box.toMap();
  }

  /// Clear all entries
  Future<void> clear() async {
    try{
      final box = await _ensureBox();
      await box.clear();
    }catch(e){
      print(e);
    }

  }

  /// Close the box
  Future<void> close() async {
    try{
      if (_box != null && _box!.isOpen) {
        await _box!.close();
        _box = null;
      }
    }catch(e){

    }

  }
}