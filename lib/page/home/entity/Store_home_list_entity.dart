class StoreHomeListEntity {
  StoreHomeListEntity({
    this.name = "",
    this.icon = "",
    this.commentCount = 0,
    this.starLevel = 0,
    this.category = "",
    this.summary = "",
    required this.appId,
  });

  final String name;
  final String icon;
  final int commentCount;
  final double starLevel;
  final String category;
  final String appId;
  final String summary;
}
