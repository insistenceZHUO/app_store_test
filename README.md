# App_store

#### 项目中用到一些关键库。
- [provider：状态管理框架。](https://pub.flutter-io.cn/packages/provider)
- [dio： 网路请求。](https://pub.flutter-io.cn/packages/dio)
- [sqlife：用于本地数据存储。](https://pub.flutter-io.cn/packages/sqflite)
- [pull_to_refresh：下拉刷新，上拉加载更多。](https://pub.flutter-io.cn/packages/pull_to_refresh)

---

项目目录结构
![](.README_images/3c9d0064.png)
#### 文件目录介绍
- common：用于存放项目中公共的模块。
  1. network网络请求的封装。
  2. config，网络请求配置。

- db：数据库模块。store_database.dart 封装了项目中数据库相关操作。
- page：页面
  1. page下的每一个文件代码一个页面的模块。
  2. 如home下，包含了一个page页面的入口==Store_home_page==、provider、view、entry。
  3. ==ProviderStoreHome==：下有一个继承自ChangeNotifier的类。用来存放页面的model。;
  4. ==StateStoreHome==:存放着页面的状态。在使用provder中做到了页面的view、state、model的分层。
  5. ==entry==: 序列化数据类。

---

####  备注
-  在列表中，评分跟评论数没有看到接口上的属性不太确认，项目中列表中评分跟评论数是通过本地随机数生成的。
-  接口中页不确定哪一个参数是作者的参数，所搜索中只是按照应用名称、应用描述来对页面进行搜索。
 

