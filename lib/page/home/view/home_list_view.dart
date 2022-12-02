import 'dart:math';

import 'package:flutter/material.dart';
import 'package:store_test/page/home/entity/Store_home_list_entity.dart';

import '../../../widget/rating_bar_indicator.dart';

class StoreHomeListView extends StatelessWidget {
  final List<StoreHomeListEntity> list;

  const StoreHomeListView({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (c, i) {
            var item = list[i];
            var index = i + 1;
            return AppItemWidget(index: index, item: item);
          },
          childCount: list.length,
        ),
      ),
    );
  }
}

class AppItemWidget extends StatelessWidget {
  const AppItemWidget({
    Key? key,
    required this.index,
    required this.item,
  }) : super(key: key);

  final int index;
  final StoreHomeListEntity item;

  @override
  Widget build(BuildContext context) {
    var radius = index % 2 == 0 ? 28.0 : 16.0;
    var ranking = Random().nextInt(5) + Random().nextDouble();
    var comment = Random().nextInt(10000);
    return Column(
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text('$index'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.network(
                    item.icon,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xff4b3636),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: ranking,
                          itemCount: 5,
                          itemSize: 12,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        Text(
                          '($comment)',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xff999999),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
