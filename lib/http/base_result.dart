/// 基础响应结果类
class BaseResult<T> {
  /// 状态码
  final int errorCode;
  /// 消息
  final String errorMsg;
  /// 数据
  final T? data;
  /// 是否成功
  /// errorCode = 0 代表执行成功，不建议依赖任何非0的 errorCode.
  /// errorCode = -1001 代表登录失效，需要重新登录。
  bool get isSuccess => errorCode == 0;

  /// 构造函数
  BaseResult({ required this.errorCode,required this.errorMsg, this.data});

  /// 从Map创建实例
  factory BaseResult.fromMap(Map<String, dynamic> map) {
    return BaseResult(
      errorCode: map['errorCode'] ?? 0,
      errorMsg: map['errorMsg'] ?? '',
      data: map['data'],
    );
  }

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'errorCode': errorCode,
      'errorMsg': errorMsg,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'BaseResult{errorCode: $errorCode, errorMsg: $errorMsg, data: $data}';
  }
}
