import 'package:flutter/material.dart';

/// 空数据界面
class LoadingEmpty extends StatefulWidget {
  const LoadingEmpty({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingEmptyState createState() => _LoadingEmptyState();
}

class _LoadingEmptyState extends State<LoadingEmpty> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text('糟糕，来晚了', style: TextStyle(color: Colors.grey, fontSize: 16)),
          SizedBox(height: 10),
          Text('暂无数据', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}
