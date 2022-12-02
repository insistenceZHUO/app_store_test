import 'package:flutter/material.dart';

import '../entity/Store_home_list_entity.dart';

class HomeRecommendView extends StatelessWidget {
  final List<StoreHomeListEntity> list;

  const HomeRecommendView({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 140,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemBuilder: (c, i) {
            var item = list[i];
            return _AppItemView(item: item);
          },
          itemCount: list.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 20,
            );
          },
        ),
      ),
    );
  }
}

class _AppItemView extends StatelessWidget {
  const _AppItemView({
    Key? key,
    required this.item,
  }) : super(key: key);

  final StoreHomeListEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.icon,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            item.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          Text(
            item.category,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }
}
