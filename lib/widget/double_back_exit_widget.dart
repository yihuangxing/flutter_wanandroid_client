import 'package:flutter/material.dart';

/// 支持双击退出的页面组件
class DoubleBackExitWidget extends StatefulWidget {
  final Widget child;
  final Duration duration; // 双击时间间隔
  final String? message; // 提示信息
  final Function()? onDoubleBack; // 双击回调
  final Function()? onSingleBack; // 单击回调

  const DoubleBackExitWidget({super.key, this.duration = const Duration(seconds: 2), required this.child, this.message, this.onDoubleBack, this.onSingleBack});

  @override
  // ignore: library_private_types_in_public_api
  _DoubleBackExitWidgetState createState() => _DoubleBackExitWidgetState();
}

class _DoubleBackExitWidgetState extends State<DoubleBackExitWidget> {
  DateTime? _lastPressedAt;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        final now = DateTime.now();
        if (_lastPressedAt != null && now.difference(_lastPressedAt!) < widget.duration) {
          widget.onDoubleBack?.call();
          return;
        }
        _lastPressedAt = now;
        widget.onSingleBack?.call();
      },
      child: widget.child,
    );
  }
}
