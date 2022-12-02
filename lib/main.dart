import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:store_test/page/home/Srore_home_page.dart';

import 'common/config/net_config/net_config.dart';
import 'common/network/base/base_http.dart';

void main() async {
  await BaseHttp.instance.init();
  BaseHttp.instance.configBaseUrl(NetConfig.baseUrl);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      // 头部触发刷新的越界距离
      headerTriggerDistance: 40,
      // 头部最大可以拖动的范围
      maxOverScrollExtent: 16,
      // 底部最大可以拖动的范围
      maxUnderScrollExtent: 10,
      //可以通过惯性滑动触发加载更多
      enableBallisticLoad: true,
      child: MaterialApp(
        title: 'Store Test',
        theme: ThemeData(
          dividerColor: const Color(0xffF3F3F5),
          dividerTheme: DividerThemeData(
            color: Color(0xffF3F3F5),
            thickness: 1,
          ),
        ),
        home: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _hideKeyboard(context),
          child: StoreHomePage(),
        ),
      ),
    );
  }

  void _hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}
