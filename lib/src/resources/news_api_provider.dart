import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'repository.dart';
import '../models/item_model.dart';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = new Client();
  
  Future<List<int>> fetchTopIds() async {
    final response = await client.get(Uri.parse('$_root/topstories.json'));
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(Uri.parse('$_root/item/$id.json'));
    final parsedJson = json.decode(response.body);
    final item = ItemModel.fromJson(parsedJson);
    return item;
  }
}

final newsApiProvider = new NewsApiProvider();