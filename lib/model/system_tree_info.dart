class SystemTreeInfo {
  final int id;
  final String name;
  final List<SystemTreeItem> children;

  // 构造函数
  SystemTreeInfo({required this.id, required this.name, required this.children});

  // 工厂函数
  factory SystemTreeInfo.fromJson(Map<String, dynamic> json) {
    return SystemTreeInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      children: (json['children'] as List).map((e) => SystemTreeItem.fromJson(e)).toList(),
    );
  }
}

class SystemTreeItem {
  final int id;
  final String name;


  // 构造函数
  SystemTreeItem({required this.id, required this.name});

  // 工厂函数
  factory SystemTreeItem.fromJson(Map<String, dynamic> json) {
    return SystemTreeItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
