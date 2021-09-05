import 'dart:math';

import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('FetchTopIds returns a list of ids', () async {
    // Setup of test case
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    final ids = await newsApi.fetchTopIds();

    // expectation
    expect(ids, [1, 2, 3, 4]);
  });

  test('FetchItem returns an item model', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode({
        "id" : 1,
        "deleted" : false,
        "type" : '',
        "by" : '',
        "time" : 0,
        "text" : '',
        "dead" : false,
        "parent" : 0,
        "kids" : [],
        "url" : '',
        "score" : 0,
        "title" : '',
        "descendants" : 0,
      }), 200);
    });

    final item = await newsApi.fetchItem(0);

    expect(item.id, 1);
  });
}