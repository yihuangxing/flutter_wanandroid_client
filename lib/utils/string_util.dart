// "title": "2026 已过 1/4：事豫则立，不预则废&mdash;&mdash;关于架构、协程与边界的思考",
/// 去掉&mdash;&mdash;符号
class StringUtil {
  /// 去掉&mdash;&mdash;符号
  static String removeMdash(String str) {
    return str.replaceAll(RegExp(r'&mdash;'), '');
  }
}
