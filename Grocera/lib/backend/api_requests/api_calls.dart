import 'dart:convert';
import 'dart:typed_data';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class SearchGroceryCall {
  static Future<ApiCallResponse> call({
    String? search = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'searchGrocery',
      apiUrl:
          'https://cqtodunohosotkryasda.supabase.co/rest/v1/groceries?name=ilike.*${search}*&select=*',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxdG9kdW5vaG9zb3Rrcnlhc2RhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDIyMTI2NzYsImV4cCI6MjAxNzc4ODY3Nn0.9-8SS0Mlkzr6qogJ1DB_JHFGiAdjj47ohtUzbWaqrF4',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxdG9kdW5vaG9zb3Rrcnlhc2RhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDIyMTI2NzYsImV4cCI6MjAxNzc4ODY3Nn0.9-8SS0Mlkzr6qogJ1DB_JHFGiAdjj47ohtUzbWaqrF4',
        'Range': '0-9',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
