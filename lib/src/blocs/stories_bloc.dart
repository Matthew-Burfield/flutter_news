import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIdsController = PublishSubject<List<int>>();
  final _itemOutputController = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemFetcherController = PublishSubject<int>();

  // Getters to Streams
  Stream<List<int>> get topIds => _topIdsController.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemOutputController.stream;

  // Getter to sinks 
  Function(int) get fetchItem => _itemFetcherController.sink.add;

  StoriesBloc() {
    _itemFetcherController
      .stream
      .transform(_itemsTransformer())
      .pipe(_itemOutputController);
  }

  void fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIdsController.sink.add(ids);
  }

  ScanStreamTransformer<int, Map<int, Future<ItemModel>>> _itemsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, id, _) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      {},
    );
  }

  void dispose() {
    _topIdsController.close();
    _itemOutputController.close();
    _itemFetcherController.close();
  }
}