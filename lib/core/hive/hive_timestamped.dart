
import 'package:hive/hive.dart';

mixin HiveTimestamped {
  @HiveField(250)
  DateTime? createdAt;
}