# LoadingDialogUtil 使用文档

## 简介

`LoadingDialogUtil` 是一个网络请求加载对话框工具类，用于在执行网络请求或其他异步任务时显示加载动画，提升用户体验。该工具类封装了对话框的显示、隐藏和自动管理功能，使用简单方便。

## 功能特点

- ✅ 显示和隐藏加载对话框
- ✅ 自动管理加载状态（显示-执行任务-隐藏）
- ✅ 支持自定义背景颜色
- ✅ 支持控制点击背景是否关闭
- ✅ 复用项目现有的加载动画组件
- ✅ 自动处理异常情况

## 主要方法

### 1. show() - 显示加载对话框

显示加载对话框，覆盖在当前页面之上。

```dart
static void show(
  BuildContext context, {
  Color backgroundColor = Colors.white,
  bool barrierDismissible = false,
})
```

#### 参数说明

| 参数名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| context | BuildContext | 必填 | 上下文对象 |
| backgroundColor | Color | Colors.white | 加载动画的背景颜色 |
| barrierDismissible | bool | false | 点击背景是否可以关闭对话框 |

#### 使用示例

```dart
// 基本使用
LoadingDialogUtil.show(context);

// 自定义背景颜色
LoadingDialogUtil.show(context, backgroundColor: Colors.grey.withOpacity(0.8));

// 允许点击背景关闭
LoadingDialogUtil.show(context, barrierDismissible: true);
```

### 2. hide() - 隐藏加载对话框

隐藏当前显示的加载对话框。

```dart
static void hide(BuildContext context)
```

#### 参数说明

| 参数名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| context | BuildContext | 必填 | 上下文对象 |

#### 使用示例

```dart
LoadingDialogUtil.hide(context);
```

### 3. showDuring() - 执行异步任务并自动管理加载状态

在执行异步任务时自动显示和隐藏加载对话框，无需手动管理。

```dart
static Future<T?> showDuring<T>(
  BuildContext context,
  Future<T> Function() task, {
  Color backgroundColor = Colors.white,
  bool barrierDismissible = false,
})
```

#### 参数说明

| 参数名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| context | BuildContext | 必填 | 上下文对象 |
| task | Future\<T\> Function() | 必填 | 异步任务函数 |
| backgroundColor | Color | Colors.white | 加载动画的背景颜色 |
| barrierDismissible | bool | false | 点击背景是否可以关闭对话框 |

#### 返回值

- 返回异步任务的结果
- 如果任务执行失败或被取消，返回 `null`

#### 使用示例

```dart
// 执行登录请求
final result = await LoadingDialogUtil.showDuring<UserInfo>(
  context,
  () async {
    return await ApiService().login(params: {
      'username': 'test',
      'password': '123456',
    });
  },
);

if (result != null) {
  // 登录成功，处理结果
  ToastUtil.showSuccess('登录成功');
} else {
  // 登录失败
  ToastUtil.showError('登录失败');
}
```

## 完整使用示例

### 示例1：基本使用（手动管理）

```dart
class _MyWidgetState extends State<MyWidget> {
  Future<void> _handleLogin() async {
    // 显示加载对话框
    LoadingDialogUtil.show(context);
    
    try {
      // 执行登录请求
      final result = await ApiService().login(params: {
        'username': 'test',
        'password': '123456',
      });
      
      if (result.isSuccess) {
        ToastUtil.showSuccess('登录成功');
        // 跳转到首页
        RouteUtils.off(Routes.home);
      } else {
        ToastUtil.showError(result.errorMsg);
      }
    } catch (e) {
      ToastUtil.showError(e.toString());
    } finally {
      // 隐藏加载对话框
      LoadingDialogUtil.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleLogin,
      child: Text('登录'),
    );
  }
}
```

### 示例2：自动管理加载状态

```dart
class _MyWidgetState extends State<MyWidget> {
  Future<void> _handleRegister() async {
    // 执行注册请求，自动管理加载状态
    final result = await LoadingDialogUtil.showDuring<UserInfo>(
      context,
      () async {
        return await ApiService().register(params: {
          'username': 'test',
          'password': '123456',
          'repassword': '123456',
        });
      },
    );

    if (result != null && result.isSuccess) {
      ToastUtil.showSuccess('注册成功');
      RouteUtils.back();
    } else {
      ToastUtil.showError(result?.errorMsg ?? '注册失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleRegister,
      child: Text('注册'),
    );
  }
}
```

### 示例3：自定义样式

```dart
class _MyWidgetState extends State<MyWidget> {
  Future<void> _fetchData() async {
    // 使用半透明灰色背景
    final result = await LoadingDialogUtil.showDuring<List<BannerInfo>>(
      context,
      () async {
        return await ApiService().getBannerList();
      },
      backgroundColor: Colors.grey.withOpacity(0.9),
      barrierDismissible: true, // 允许点击背景关闭
    );

    if (result != null) {
      // 处理数据
      setState(() {
        bannerList = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _fetchData,
      child: Text('获取数据'),
    );
  }
}
```

### 示例4：多个异步任务

```dart
class _MyWidgetState extends State<MyWidget> {
  Future<void> _loadAllData() async {
    // 同时执行多个请求
    final results = await LoadingDialogUtil.showDuring<List<dynamic>>(
      context,
      () async {
        return await Future.wait([
          ApiService().getBannerList(),
          ApiService().getHomeArticleList(),
          ApiService().getProjectMenuList(),
        ]);
      },
    );

    if (results != null) {
      // 处理所有结果
      final banners = results[0] as List<BannerInfo>;
      final articles = results[1] as HomeArticle;
      final projects = results[2] as List<ProductMenuInfo>;
      
      setState(() {
        // 更新UI
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _loadAllData,
      child: Text('加载所有数据'),
    );
  }
}
```

## 注意事项

### 1. Context 使用

确保传入的 `context` 是有效的，并且对应的 Widget 仍然在 Widget 树中。如果在异步任务执行过程中页面被销毁，可能会导致错误。

**错误示例：**

```dart
// ❌ 错误：在异步任务中使用过期的context
Future<void> _handleLogin() async {
  LoadingDialogUtil.show(context);
  await Future.delayed(Duration(seconds: 2));
  // 此时页面可能已经被销毁，context无效
  LoadingDialogUtil.hide(context); // 可能报错
}
```

**正确示例：**

```dart
// ✅ 正确：使用mounted检查
Future<void> _handleLogin() async {
  LoadingDialogUtil.show(context);
  await Future.delayed(Duration(seconds: 2));
  if (mounted) {
    LoadingDialogUtil.hide(context);
  }
}
```

### 2. 异常处理

`showDuring()` 方法会自动捕获异常并关闭对话框，但不会处理异常。需要在调用处处理异常。

```dart
try {
  final result = await LoadingDialogUtil.showDuring<UserInfo>(
    context,
    () async {
      return await ApiService().login(params: {'username': 'test', 'password': '123456'});
    },
  );
  
  if (result != null) {
    // 处理成功结果
  }
} catch (e) {
  // 处理异常
  ToastUtil.showError(e.toString());
}
```

### 3. 对话框重叠

避免在对话框显示期间再次调用 `show()` 方法，这会导致对话框重叠。

```dart
// ❌ 错误：对话框重叠
LoadingDialogUtil.show(context);
LoadingDialogUtil.show(context); // 会显示第二个对话框

// ✅ 正确：先隐藏再显示
LoadingDialogUtil.hide(context);
LoadingDialogUtil.show(context);
```

### 4. barrierDismissible 参数

当 `barrierDismissible` 设置为 `true` 时，用户可以点击背景关闭对话框。这可能导致异步任务仍在执行，但对话框已关闭的情况。

```dart
// 如果允许点击背景关闭，需要处理任务仍在执行的情况
final result = await LoadingDialogUtil.showDuring<UserInfo>(
  context,
  () async {
    return await ApiService().login(params: {'username': 'test', 'password': '123456'});
  },
  barrierDismissible: true, // 用户可以点击背景关闭
);

// result可能为null（用户关闭了对话框）或任务结果
if (result != null) {
  // 处理结果
}
```

## 最佳实践

### 1. 使用 showDuring() 代替手动管理

推荐使用 `showDuring()` 方法，因为它会自动处理异常情况，确保对话框能够正确关闭。

```dart
// ✅ 推荐
final result = await LoadingDialogUtil.showDuring<UserInfo>(
  context,
  () async => await ApiService().login(params: params),
);

// ❌ 不推荐（容易忘记关闭对话框）
LoadingDialogUtil.show(context);
try {
  final result = await ApiService().login(params: params);
  // 处理结果
} finally {
  LoadingDialogUtil.hide(context);
}
```

### 2. 统一背景颜色

建议在项目中统一加载对话框的背景颜色，保持UI一致性。

```dart
// 定义常量
class AppColors {
  static const Color loadingBackground = Colors.white;
}

// 使用
LoadingDialogUtil.show(
  context,
  backgroundColor: AppColors.loadingBackground,
);
```

### 3. 结合状态管理

在使用状态管理（如Provider、Bloc等）时，可以在状态变化时自动显示和隐藏加载对话框。

```dart
// 使用Provider示例
class LoginViewModel extends ChangeNotifier {
  Future<void> login(BuildContext context, String username, String password) async {
    final result = await LoadingDialogUtil.showDuring<UserInfo>(
      context,
      () async {
        return await ApiService().login(params: {
          'username': username,
          'password': password,
        });
      },
    );

    if (result != null && result.isSuccess) {
      // 更新状态
      notifyListeners();
    }
  }
}
```

## 常见问题

### Q1: 对话框不显示？

**A:** 检查以下几点：
1. 确保 `context` 有效
2. 确保在 Widget 树构建完成后调用（如在按钮点击事件中）
3. 检查是否有其他对话框正在显示

### Q2: 对话框无法关闭？

**A:** 检查以下几点：
1. 确保 `hide()` 方法使用了正确的 `context`
2. 检查 `barrierDismissible` 参数设置
3. 确保没有多次调用 `show()` 方法

### Q3: 异步任务执行失败，对话框未关闭？

**A:** 使用 `showDuring()` 方法，它会自动处理异常并关闭对话框。

### Q4: 如何自定义加载动画？

**A:** 修改 `LoadingWidget` 组件，或创建新的加载动画组件，然后在 `LoadingDialogUtil` 中使用。

## 相关文件

- [LoadingWidget](../lib/widget/loading_widget.dart) - 加载动画组件
- [LoadingDialogUtil](../lib/utils/loading_dialog_util.dart) - 加载对话框工具类

## 更新日志

### v1.0.0 (2026-04-03)
- ✨ 初始版本
- ✨ 支持显示、隐藏加载对话框
- ✨ 支持自动管理加载状态
- ✨ 支持自定义背景颜色
- ✨ 支持控制点击背景关闭
