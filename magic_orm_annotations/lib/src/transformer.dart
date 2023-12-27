/// {@category Models}
abstract class Transformer {
  const Transformer();

  String transform(String column, String table);
}
