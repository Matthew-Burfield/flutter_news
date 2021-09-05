import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  
  List<Source> sources = <Source>[
    newsDbProvider,
    newsApiProvider,
  ];
  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];
  
  Future<List<int>> fetchTopIds() async {
    Source source;
    late List<int> topIds;

    for (source in sources) {
      topIds = await source.fetchTopIds();
      if (topIds.length > 0) {
        break;
      }
    }

    return topIds;
  }
  
  Future<ItemModel> fetchItem(int id) async {
    late Source source;
    ItemModel? item;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    if (item == null) {
      throw Error();
    }

    for (Cache cache in caches) {
      if (cache as NewsDbProvider != source as NewsDbProvider) {
        cache.addItem(item);
      }
    }

    return item;
  }
}

abstract class Source {
  Future<ItemModel?> fetchItem(int id);

  Future<List<int>> fetchTopIds();
}

abstract class Cache {
  void addItem(ItemModel item);
}