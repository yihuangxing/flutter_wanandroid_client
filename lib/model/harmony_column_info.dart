//上面对应的数据，生成数据实体
class HarmonyosColumn {
  HarmonyosColumnLinks links;
  HarmonyosColumnOpenSources open_sources;
  HarmonyosColumnTools tools;

  // 构造函数
  HarmonyosColumn({required this.links, required this.open_sources, required this.tools});

  //工厂模式
  factory HarmonyosColumn.fromJson(Map<String, dynamic> json) {
    return HarmonyosColumn(
      links: HarmonyosColumnLinks.fromJson(json['links']),
      open_sources: HarmonyosColumnOpenSources.fromJson(json['open_sources']),
      tools: HarmonyosColumnTools.fromJson(json['tools']),
    );
  }
}

class HarmonyosColumnLinks {
  int id;
  String name;
  String link;
  List<HarmonyosColumnArticle> articleList = [];
  // 构造函数
  HarmonyosColumnLinks({required this.id, required this.name, required this.link, required this.articleList});

  // 工厂模式
  factory HarmonyosColumnLinks.fromJson(Map<String, dynamic> json) {
    return HarmonyosColumnLinks(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      link: json['link'] ?? '',
      articleList: (json['articleList'] as List).map((e) => HarmonyosColumnArticle.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class HarmonyosColumnArticle {
  int audit;
  String author;
  bool collect;
  int id;
  String chapterName;
  String desc;
  String superChapterName;
  String niceDate;
  String link;
  // 构造函数
  HarmonyosColumnArticle({
    required this.audit,
    required this.author,
    required this.chapterName,
    required this.desc,
    required this.superChapterName,
    required this.niceDate,
    required this.link,
    required this.collect,
    required this.id,
  });

  // 工厂模式
  factory HarmonyosColumnArticle.fromJson(Map<String, dynamic> json) {
    return HarmonyosColumnArticle(
      audit: json['audit'] ?? 0,
      author: json['author'] ?? '',
      chapterName: json['chapterName'] ?? '',
      desc: json['desc'] ?? '',
      superChapterName: json['superChapterName'] ?? '',
      niceDate: json['niceDate'] ?? '',
      link: json['link'] ?? '',
      collect: json['collect'] ?? false,
      id: json['id'] ?? 0,
    );
  }
}

class HarmonyosColumnOpenSources {
  int id;
  String name;
  List<HarmonyosColumnArticle> articleList = [];
  // 构造函数
  HarmonyosColumnOpenSources({required this.id, required this.name, required this.articleList});

  // 工厂模式
  factory HarmonyosColumnOpenSources.fromJson(Map<String, dynamic> json) {
    return HarmonyosColumnOpenSources(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      articleList: (json['articleList'] as List).map((e) => HarmonyosColumnArticle.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class HarmonyosColumnTools {
  int id;
  String name;
  List<HarmonyosColumnArticle> articleList = [];
  // 构造函数
  HarmonyosColumnTools({required this.id, required this.name, required this.articleList});

  // 工厂模式
  factory HarmonyosColumnTools.fromJson(Map<String, dynamic> json) {
    return HarmonyosColumnTools(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      articleList: (json['articleList'] as List).map((e) => HarmonyosColumnArticle.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
