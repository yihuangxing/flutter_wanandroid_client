class ProjectListInfo {
  int curPage;
  List<ProjectInfo> datas;

  //构造方法
  ProjectListInfo({required this.curPage, this.datas = const []});

  //工厂方法
  factory ProjectListInfo.fromJson(Map<String, dynamic> json) =>
      ProjectListInfo(curPage: json['curPage'], datas: (json['datas'] as List).map((e) => ProjectInfo.fromJson(e)).toList());
}

class ProjectInfo {
  String author;
  String chapterName;
  String desc;
  String niceShareDate;
  String link;
  String superChapterName;
  String title;
  int id;
  bool collect;

  //构造方法
  ProjectInfo({
    required this.author,
    required this.chapterName,
    required this.desc,
    required this.niceShareDate,
    required this.link,
    required this.superChapterName,
    required this.title,
    required this.id,
    required this.collect,
  });

  //工厂方法
  factory ProjectInfo.fromJson(Map<String, dynamic> json) => ProjectInfo(
    author: json['author'] ?? '',
    chapterName: json['chapterName'] ?? '',
    desc: json['desc'] ?? '',
    niceShareDate: json['niceShareDate'] ?? '',
    link: json['link'] ?? '',
    superChapterName: json['superChapterName'] ?? '',
    title: json['title'] ?? '',
    id: json['id'] ?? 0,
    collect: json['collect'] ?? false,
  );
}
