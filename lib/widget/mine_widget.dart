import 'package:flutter/material.dart';

class MineWidget extends StatefulWidget {
  const MineWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MineWidgetState createState() => _MineWidgetState();
}

class _MineWidgetState extends State<MineWidget>  with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(child: const Text('我的'));
  }
}
