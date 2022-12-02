import '../entity/Store_home_list_entity.dart';

class StateStoreHome {
  List<StoreHomeListEntity> list = [];

  List<StoreHomeListEntity> recommendList = [];

  bool isRefresh = true;
  bool hasMove = true;
  String searchText = '';
  List<StoreHomeListEntity> searchResult = [];
}


