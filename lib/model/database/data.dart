import 'package:maybank_todo/model/database/database_model.dart';

abstract class Data<T> {
  String get tableName;

  List<DatabaseModel> setDatabase();

  String get createQuery {
    List<String> list = [];
    setDatabase().forEach((element) {
      list.add(element.getDbString());
    });
    return "CREATE TABLE IF NOT EXISTS $tableName(${list.join(", ")})";
  }

  String get dropQuery {
    return "DROP TABLE IF EXISTS $tableName";
  }
}
