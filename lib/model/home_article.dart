class HomeArticle {
  int curPage;
  List<HomeArticleInfo> datas;

  HomeArticle({required this.curPage, required this.datas});

  /// 从JSON创建HomeArticle实例
  factory HomeArticle.fromJson(Map<String, dynamic> json) => HomeArticle(
    curPage: json['curPage'] ?? 0,
    datas: (json['datas'] as List<dynamic>).map((e) => HomeArticleInfo.fromJson(e)).toList(),
  );
}

class HomeArticleInfo {
  bool adminAdd;
  int originId;
  String apkLink;
  int audit;
  String author;
  bool canEdit;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String descMd;
  String envelopePic;
  bool fresh;
  String host;
  int id;
  bool isAdminAdd;
  String link;
  String niceDate;
  String niceShareDate;
  String origin;
  String prefix;
  String projectLink;
  int publishTime;
  int realSuperChapterId;
  int selfVisible;
  int shareDate;
  String shareUser;
  int superChapterId;
  String superChapterName;
  List<String> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;

  /// 构造函数
  HomeArticleInfo({
    required this.adminAdd,
    required this.originId,
    required this.apkLink,
    required this.audit,
    required this.author,
    required this.canEdit,
    required this.chapterId,
    required this.chapterName,
    required this.collect,
    required this.courseId,
    required this.desc,
    required this.descMd,
    required this.envelopePic,
    required this.fresh,
    required this.host,
    required this.id,
    required this.isAdminAdd,
    required this.link,
    required this.niceDate,
    required this.niceShareDate,
    required this.origin,
    required this.prefix,
    required this.projectLink,
    required this.publishTime,
    required this.realSuperChapterId,
    required this.selfVisible,
    required this.shareDate,
    required this.shareUser,
    required this.superChapterId,
    required this.superChapterName,
    required this.tags,
    required this.title,
    required this.type,
    required this.userId,
    required this.visible,
    required this.zan,
  });

  /// 从JSON创建HomeArticleInfo实例
  factory HomeArticleInfo.fromJson(Map<String, dynamic> json) => HomeArticleInfo(
    adminAdd: json['adminAdd'] ?? false,
    originId: json['originId'] ?? -1,
    apkLink: json['apkLink'] ?? '',
    audit: json['audit'] ?? 0,
    author: json['author'] ?? '',
    canEdit: json['canEdit'] ?? false,
    chapterId: json['chapterId'] ?? 0,
    chapterName: json['chapterName'] ?? '',
    collect: json['collect'] ?? false,
    courseId: json['courseId'] ?? 0,
    desc: json['desc'] ?? '',
    descMd: json['descMd'] ?? '',
    envelopePic: json['envelopePic'] ?? '',
    fresh: json['fresh'] ?? false,
    host: json['host'] ?? '',
    id: json['id'] ?? 0,
    isAdminAdd: json['isAdminAdd'] ?? false,
    link: json['link'] ?? '',
    niceDate: json['niceDate'] ?? '',
    niceShareDate: json['niceShareDate'] ?? '',
    origin: json['origin'] ?? '',
    prefix: json['prefix'] ?? '',
    projectLink: json['projectLink'] ?? '',
    publishTime: json['publishTime'] ?? 0,
    realSuperChapterId: json['realSuperChapterId'] ?? 0,
    selfVisible: json['selfVisible'] ?? 0,
    shareDate: json['shareDate'] ?? 0,
    shareUser: json['shareUser'] ?? '',
    superChapterId: json['superChapterId'] ?? 0,
    superChapterName: json['superChapterName'] ?? '',
    tags: json['tags'] != null ? (json['tags'] as List<dynamic>).map((e) => e as String).toList() : [],
    title: json['title'] ?? '',
    type: json['type'] ?? 0,
    userId: json['userId'] ?? 0,
    visible: json['visible'] ?? 0,
    zan: json['zan'] ?? 0,
  );
}
