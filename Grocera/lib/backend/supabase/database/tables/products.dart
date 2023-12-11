import '../database.dart';

class ProductsTable extends SupabaseTable<ProductsRow> {
  @override
  String get tableName => 'products';

  @override
  ProductsRow createRow(Map<String, dynamic> data) => ProductsRow(data);
}

class ProductsRow extends SupabaseDataRow {
  ProductsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductsTable();

  int get productId => getField<int>('product_id')!;
  set productId(int value) => setField<int>('product_id', value);

  String get productName => getField<String>('product_name')!;
  set productName(String value) => setField<String>('product_name', value);

  double get price => getField<double>('price')!;
  set price(double value) => setField<double>('price', value);

  int? get groceryId => getField<int>('grocery_id');
  set groceryId(int? value) => setField<int>('grocery_id', value);
}
