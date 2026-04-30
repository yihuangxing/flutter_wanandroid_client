import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

/// 加载界面
class LoadingWidget extends StatefulWidget {
  //控制背景颜色
  final Color backgroundColor;
  //宽度
  final double width;
  //高度
  final double height;

  const LoadingWidget({super.key, this.backgroundColor = Colors.white, this.width = 110, this.height = 110});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  final List<Color> _kDefaultRainbowColors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: widget.width,
        height: widget.height,
        color: widget.backgroundColor,
        child: LoadingIndicator(indicatorType: Indicator.pacman, colors: _kDefaultRainbowColors, strokeWidth: 2),
      ),
    );
  }
}
