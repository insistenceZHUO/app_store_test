import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'entity/Store_home_list_entity.dart';
import 'provider/provider_store_home.dart';
import 'view/home_list_view.dart';
import 'view/home_recommend_view.dart';
import '../../db/store_database.dart';

class StoreHomePage extends StatefulWidget {
  StoreHomePage({Key? key}) : super(key: key);

  @override
  _StoreHomePageState createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  late ProviderStoreHome _provider;

  final RefreshController _refreshController = RefreshController(
      initialRefresh: true, initialRefreshStatus: RefreshStatus.canRefresh);

  @override
  void initState() {
    super.initState();
    _textController.addListener(inputChange);
  }

  void inputChange() {
    _provider.searchList(_textController.text);
  }

  void _onRefresh(ProviderStoreHome provider) async {
    try {
      await _provider.requestHomeList();
      await _provider.requestRecommend();
    } finally {
      _refreshController.refreshCompleted();
      _provider.disable = false;
    }
  }

  StoreDatabase database = StoreDatabase.instance;

  var offset = 0;

  TextEditingController _textController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProviderStoreHome(),
      child: Builder(builder: (context) {
        _provider = context.read<ProviderStoreHome>();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppbar(),
          body: SafeArea(
            child: SmartRefresher(
              enablePullUp: context
                  .select((ProviderStoreHome value) => value.state.hasMove),
              enablePullDown: context
                  .select((ProviderStoreHome value) => value.state.isRefresh),
              controller: _refreshController,
              onRefresh: () => _onRefresh(_provider),
              onLoading: () async {
                offset += pageSize;
                try {
                  await _provider.loadMore(offset);
                } finally {
                  _refreshController.loadComplete();
                }
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: Divider()),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Recommend',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Selector<ProviderStoreHome, List<StoreHomeListEntity>>(
                    shouldRebuild: (p, n) => true,
                    selector: (context, provider) =>
                        provider.state.recommendList,
                    builder: (context, list, child) {
                      return HomeRecommendView(
                        list: context.select(
                          (ProviderStoreHome value) =>
                              value.state.recommendList,
                        ),
                      );
                    },
                  ),
                  _viewCheckoutSearchView(context),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  ValueListenableBuilder _viewCheckoutSearchView(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _textController,
      builder: (context, value, _) {
        if (value.text.isNotEmpty) {
          return Selector<ProviderStoreHome, List<StoreHomeListEntity>>(
            selector: (context, provider) {
              return provider.state.searchResult;
            },
            shouldRebuild: (p, n) => true,
            builder: (context, value, child) {
              return StoreHomeListView(
                list: value,
              );
            },
          );
        }
        return Selector<ProviderStoreHome, List<StoreHomeListEntity>>(
          selector: (context, provider) {
            return provider.state.list;
          },
          shouldRebuild: (p, n) => true,
          builder: (context, value, child) {
            return StoreHomeListView(
              list: value,
            );
          },
        );
      },
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 24,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          // color: Colors.blue,
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(Icons.search),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: '搜索',
                  hintStyle: TextStyle(color: Color(0xff999999)),
                  hintMaxLines: 1,
                  // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
