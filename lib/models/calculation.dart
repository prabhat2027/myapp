import 'package:hive/hive.dart';

part 'calculation.g.dart';


@HiveType(typeId: 0)
class Calculation extends HiveObject {
  @HiveField(0)
  final String expression;

  @HiveField(1)
  final String result;

  @HiveField(2)
  final String note;

  @HiveField(3)
  final DateTime time;

  Calculation({
    required this.expression,
    required this.result,
    required this.note,
    required this.time,
  });
}
