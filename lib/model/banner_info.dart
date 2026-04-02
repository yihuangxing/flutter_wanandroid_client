// {
//       "desc": "我们支持订阅啦~",
//       "id": 30,
//       "imagePath": "https://www.wanandroid.com/blogimgs/42da12d8-de56-4439-b40c-eab66c227a4b.png",
//       "isVisible": 1,
//       "order": 2,
//       "title": "我们支持订阅啦~",
//       "type": 0,
//       "url": "https://www.wanandroid.com/blog/show/3352"
// }

class BannerInfo {
  String desc;
  int id;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  /// 构造函数
  BannerInfo({
    required this.desc,
    required this.id,
    required this.imagePath,
    required this.isVisible,
    required this.order,
    required this.title,
    required this.type,
    required this.url,
  });

  /// 从JSON创建BannerInfo实例
  factory BannerInfo.fromJson(Map<String, dynamic> json) => BannerInfo(
    desc: json['desc'] ?? '',
    id: json['id'] ?? 0,
    imagePath: json['imagePath'] ?? '',
    isVisible: json['isVisible'] ?? 0,
    order: json['order'] ?? 0,
    title: json['title'] ?? '',
    type: json['type'] ?? 0,
    url: json['url'] ?? '',
  );
}
