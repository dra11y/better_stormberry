import 'package:magic_orm/magic_orm.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';

part 'model.schema.dart';

@Model()
abstract class A {
  @PrimaryKey()
  String get id;

  String get a;
  int get b;
  double get c;
  bool get d;
  List<int> get e;
  List<double> get f;
}

@Model()
abstract class B {
  @PrimaryKey()
  @AutoIncrement()
  int get id;

  A get a;

  String get b;
  int get c;
  double get d;
  bool get e;
}
