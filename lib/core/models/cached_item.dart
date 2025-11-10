import 'package:hive/hive.dart';

part 'cached_item.g.dart'; // This is required for the generated code

@HiveType(typeId: 101)
class CachedItem<T> extends HiveObject {
  @HiveField(0)
  final dynamic item;

  @HiveField(1)
  final DateTime cachedAt;

  CachedItem({
    required this.item,
    required this.cachedAt,
  });
}
