import '../database.dart';

class OrdersTable extends SupabaseTable<OrdersRow> {
  @override
  String get tableName => 'orders';

  @override
  OrdersRow createRow(Map<String, dynamic> data) => OrdersRow(data);
}

class OrdersRow extends SupabaseDataRow {
  OrdersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrdersTable();

  int get orderId => getField<int>('order_id')!;
  set orderId(int value) => setField<int>('order_id', value);

  DateTime? get orderTime => getField<DateTime>('order_time');
  set orderTime(DateTime? value) => setField<DateTime>('order_time', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  int? get userId => getField<int>('user_id');
  set userId(int? value) => setField<int>('user_id', value);

  int? get groceryId => getField<int>('grocery_id');
  set groceryId(int? value) => setField<int>('grocery_id', value);
}
