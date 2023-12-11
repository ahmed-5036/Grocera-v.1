import '../database.dart';

class GroceriesTable extends SupabaseTable<GroceriesRow> {
  @override
  String get tableName => 'groceries';

  @override
  GroceriesRow createRow(Map<String, dynamic> data) => GroceriesRow(data);
}

class GroceriesRow extends SupabaseDataRow {
  GroceriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GroceriesTable();

  int get groceryId => getField<int>('grocery_id')!;
  set groceryId(int value) => setField<int>('grocery_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String get address => getField<String>('address')!;
  set address(String value) => setField<String>('address', value);

  String? get groceryImage => getField<String>('grocery_image');
  set groceryImage(String? value) => setField<String>('grocery_image', value);
}
