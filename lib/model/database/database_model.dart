class DatabaseModel {
  final String columnName;
  final DbDataType columnType;
  final bool isPrimarykey;
  DatabaseModel(this.columnName,
      {required this.columnType, this.isPrimarykey = false});

  String getDbString() {
    return "$columnName ${columnType.typeString}${(isPrimarykey) ? " PRIMARY KEY" : ""}";
  }
}

enum DbDataType { INTEGER, REAL, TEXT, BLOB }

extension DbDataTypeExtension on DbDataType {
  String get typeString {
    switch (this) {
      case DbDataType.INTEGER:
        return "INTEGER";
      case DbDataType.REAL:
        return "REAL";
      case DbDataType.TEXT:
        return "TEXT";
      case DbDataType.BLOB:
        return "BLOB";
      default:
        return "";
    }
  }
}
