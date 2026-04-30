import 'package:flutter/material.dart';

/// 加载错误界面
class LoadingErrorWidget extends StatefulWidget {
  final String error;
  final Function() retry;
  const LoadingErrorWidget({super.key, required this.error, required this.retry});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingErrorWidgetState createState() => _LoadingErrorWidgetState();
}

class _LoadingErrorWidgetState extends State<LoadingErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/ic_network_error.png', width: 100, height: 100),
          const SizedBox(height: 16),
          Text('加载失败',style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 10),
          Text(widget.error,style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),side: BorderSide(color: Colors.red)),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              //去掉默认阴影  
              shadowColor: Colors.transparent,
            ),
            // ✅ 直接使用 BaseController 的 retry
            onPressed: () => widget.retry(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}
