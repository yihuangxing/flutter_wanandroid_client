# 网络请求框架使用文档

## 1. 目录结构

```
lib/http/
├── network_config.dart    # 网络配置类
├── network_manager.dart   # 网络请求管理器
├── api_service.dart       # API服务类
├── base_result.dart       # 基础响应结果类
├── request_interceptor.dart # 请求拦截器
├── response_interceptor.dart # 响应拦截器
└── README.md              # 使用文档
```

## 2. 核心功能

### 2.1 基础配置
- 基础URL设置
- 超时时间配置
- 默认请求头管理

### 2.2 拦截器
- **请求拦截器**：打印请求信息，可用于添加认证token等
- **响应拦截器**：打印响应和错误信息，统一处理响应

### 2.3 请求方法
- GET：获取数据
- POST：提交数据
- PUT：更新数据
- DELETE：删除数据
- UPLOAD：上传文件
- DOWNLOAD：下载文件

### 2.4 错误处理
- 网络错误统一处理
- 业务错误由调用方处理

### 2.5 其他功能
- 请求取消
- 上传/下载进度回调

## 3. 快速开始

### 3.1 配置基础URL

在 `network_config.dart` 中配置基础URL：

```dart
class NetworkConfig {
  static const String baseUrl = 'https://api.example.com';
  // 其他配置...
}
```

### 3.2 创建API服务

在 `api_service.dart` 中定义API方法：

```dart
class ApiService {
  // 获取新闻分类
  Future<BaseResult<List<NewsCategoryInfo>>> getNewsCategory({
    required String appId,
    required String appSecret,
  }) async {
    final result = await _networkManager.get(
      '/news/types/v2',
      queryParameters: {'app_id': appId, 'app_secret': appSecret},
    );
    // 处理数据...
  }
  
  // 其他API方法...
}
```

### 3.3 使用API服务

```dart
// 导入API服务
import 'package:flutter_chinese_poetry/api/api_service.dart';

// 使用API服务
void fetchData() async {
  try {
    final result = await ApiService().getNewsCategory(
      appId: 'your_app_id',
      appSecret: 'your_app_secret',
    );
    
    if (result.isSuccess) {
      // 处理成功数据
      print('新闻分类: ${result.data}');
    } else {
      // 处理业务错误
      print('错误: ${result.msg}');
    }
  } catch (e) {
    // 处理网络错误
    print('网络错误: $e');
  }
}
```

## 4. 高级用法

### 4.1 请求取消

```dart
// 创建取消令牌
CancelToken cancelToken = CancelToken();

// 发起请求
ApiService().getNewsList(
  appId: 'your_app_id',
  appSecret: 'your_app_secret',
  typeId: '532',
  page: 1,
).catchError((error) {
  if (CancelToken.isCancel(error)) {
    print('请求已取消');
  }
});

// 取消请求
cancelToken.cancel('取消请求');

// 或者取消所有请求
NetworkManager().cancelAll();
```

### 4.2 文件上传

```dart
void uploadFile() async {
  try {
    final result = await ApiService().uploadAvatar(
      'path/to/file.jpg',
      onSendProgress: (int sent, int total) {
        print('上传进度: ${(sent / total * 100).toStringAsFixed(0)}%');
      },
    );
    print('上传结果: ${result.data}');
  } catch (e) {
    print('上传错误: $e');
  }
}
```

### 4.3 文件下载

```dart
void downloadFile() async {
  try {
    final result = await ApiService().downloadFile(
      'https://example.com/file.pdf',
      'path/to/save/file.pdf',
      onReceiveProgress: (int received, int total) {
        print('下载进度: ${(received / total * 100).toStringAsFixed(0)}%');
      },
    );
    print('下载结果: $result');
  } catch (e) {
    print('下载错误: $e');
  }
}
```

## 5. 注意事项

1. **错误处理**：
   - 网络错误会抛出异常，需要用 try-catch 捕获
   - 业务错误（code != 1）不会抛出异常，需要通过 `result.isSuccess` 判断

2. **性能优化**：
   - 避免在短时间内发起大量相同的请求
   - 对于大文件上传/下载，使用进度回调显示进度

3. **安全性**：
   - 对于需要认证的请求，确保在请求拦截器中正确添加认证信息

## 6. 最佳实践

1. **封装API服务**：
   - 所有API调用都通过 `ApiService` 进行，不要直接使用 `NetworkManager`
   - 在 `ApiService` 中处理数据类型转换，返回类型安全的结果

2. **错误处理**：
   - 网络错误：显示通用错误提示（如网络连接失败）
   - 业务错误：显示具体错误信息（如用户名已存在）
   - 未知错误：显示友好的错误提示

3. **UI体验**：
   - 首次加载：显示加载指示器
   - 网络错误：显示错误提示，提供重试按钮
   - 空数据：显示空状态提示

## 7. 总结

本网络请求框架提供了以下核心优势：

- **简洁易用**：统一的API调用方式，类型安全的返回结果
- **功能完善**：支持所有常用HTTP方法，文件上传下载
- **灵活扩展**：支持自定义拦截器，可根据需求扩展功能
- **错误处理**：统一的错误处理机制，便于调试和用户体验

通过合理使用本框架，可以显著提升应用的网络请求性能和用户体验，同时降低开发难度和维护成本。