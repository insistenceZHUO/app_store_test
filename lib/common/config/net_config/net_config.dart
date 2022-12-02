class NetConfig {
  static const String baseUrl = "https://itunes.apple.com/hk";
}

class RequestApis {
  static const String list = "/rss/topgrossingapplications/limit=100/json";
  static const String recommend = "/rss/topfreeapplications/limit=10/json";
}
