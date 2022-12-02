import 'package:flutter/material.dart';
import 'package:store_test/common/network/base/base_http.dart';
import 'package:store_test/page/home/entity/Store_home_list_entity.dart';
import 'package:store_test/page/home/provider/state_store_home.dart';
import 'dart:convert';

import '../../../common/config/net_config/net_config.dart';
import '../../../db/store_database.dart';

// https://itunes.apple.com/hk/rss/topgrossingapplications/limit=${limit}/json
// https://itunes.apple.com/hk/rss/topfreeapplications/limit=${limit}/json
// https://itunes.apple.com/hk/lookup?id=${id}
const int pageSize = 10;
class ProviderStoreHome extends ChangeNotifier {
  StateStoreHome state = StateStoreHome();
  StoreDatabase database = StoreDatabase.instance;
  Future searchList(String text) async {
    var result = await database.queryKeyword(text);
    state.searchResult = result.translateEntity;
    notifyListeners();
  }

  Future requestHomeList() async {
    var dbData = await database.queryApp(offset: pageSize);
    var firstList = [];
    if (dbData.isNotEmpty) {
      firstList = dbData.length >= pageSize ? dbData.sublist(0, pageSize) : dbData;
      state.list.addAll(firstList.translateEntity);
      notifyListeners();
      return;
    }

    var result = await BaseHttp.instance.open(RequestApis.list);
    /// 获取首页列表的数据, 如果第一次进入，从请求中获取，然后在存储在数据库中。
    if (result is! WDError) {
      var data = jsonDecode(result);
      var list = List<Map<String, dynamic>>.from(data["feed"]["entry"]);
      List<Map<String, dynamic>> cacheData = [];

      /// 先保存100条数据。到数据库。
      cacheData = List<Map<String, dynamic>>.from(list.translateJson);
      await database.insert(cacheData);
      firstList = cacheData.length >= pageSize ? cacheData.sublist(0, pageSize) : cacheData;
      state.list.addAll(firstList.translateEntity);
      notifyListeners();
    }
  }

  Future requestRecommend() async {
    var result = await BaseHttp.instance.open(RequestApis.recommend);
    if (result is! WDError) {
      var data = jsonDecode(result);
      var list = List<Map<String, dynamic>>.from(data["feed"]["entry"]);
      state.recommendList = list.translateJson.translateEntity;
      notifyListeners();
    }
  }

  set disable(bool value) {
    state.isRefresh = false;
    notifyListeners();
  }

  Future loadMore(int offset) async {
    var result = await database.queryApp(offset: offset);
    state.list.addAll(result.translateEntity);

    if (offset >= 100) {
      state.hasMove = false;
    }
    notifyListeners();
  }
}

extension _translateParams on List {
  List<StoreHomeListEntity> get translateEntity {
    var data = this.map((e) {
      String name = e[TableName.name]!.toString();
      String icon = e[TableName.icon]!.toString();
      String category = e[TableName.category]!.toString();
      String appId = e[TableName.appId]!.toString();
      String summary = e[TableName.summary]!.toString();
      return StoreHomeListEntity(
        name: name,
        icon: icon,
        category: category,
        appId: appId,
        summary: summary,
      );
    });
    return data.toList();
  }

  List<Map> get translateJson {
    var data = this.map((e) {
      String name = e["im:name"]["label"];
      String icon = e["im:image"][1]["label"];
      String category = e["category"]["attributes"]["label"];
      String appId = e["id"]["attributes"]["im:id"];
      String summary = e["summary"]["label"];
      return {
        TableName.name: name,
        TableName.icon: icon,
        TableName.category: category,
        TableName.appId: appId,
        TableName.summary: summary,
      };
    }).toList();
    return data;
  }
}
