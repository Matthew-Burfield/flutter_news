import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({required this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> streamSnapshot) {
        if (!streamSnapshot.hasData) {
          return Text('Loading...');
        }

        return FutureBuilder(
          future: streamSnapshot.data?[itemId],
          builder: (context, AsyncSnapshot<ItemModel> futureSnapshot) {
            if (!futureSnapshot.hasData) {
              return Text('Loading...');
            }
            return Column(
              children: [
                buildTile(futureSnapshot.data as ItemModel),
                Divider(),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildTile(ItemModel item) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text('${item.score} votes'),
      trailing: Column(
        children: [
          Icon(Icons.comment),
          Text('${item.descendants}'),
        ],
      ),
    );
  }
}