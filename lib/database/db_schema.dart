class DBSchema{
  static const postTable = '''CREATE TABLE post_table (
  id INTEGER PRIMARY KEY NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL
  )''';
}