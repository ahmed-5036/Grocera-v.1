import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  int get uid => getField<int>('uid')!;
  set uid(int value) => setField<int>('uid', value);

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  DateTime? get createdTime => getField<DateTime>('created_time');
  set createdTime(DateTime? value) => setField<DateTime>('created_time', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);
}
