import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 底部弹出菜单工具类
class BottomSheetUtil {
  /// 显示底部操作菜单
  ///
  /// [context] BuildContext
  /// [items] 菜单项列表，每项包含 title 和可选的 icon
  /// [onItemTap] 点击回调，返回被点击的索引
  static void show({required BuildContext context, required List<BottomSheetItem> items, void Function(int index)? onItemTap}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => _BottomSheetWidget(items: items, onItemTap: onItemTap),
    );
  }

  /// 带标题的底部弹出菜单
  static void showWithTitle({
    required BuildContext context,
    String? title,
    required List<BottomSheetItem> items,
    void Function(int index)? onItemTap,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => _BottomSheetWidget(items: items, onItemTap: onItemTap, title: title),
    );
  }

  /// 使用 GetX 上下文显示（不需要 BuildContext）
  static void showByGet({required List<BottomSheetItem> items, void Function(int index)? onItemTap}) {
    Get.bottomSheet(
      _BottomSheetWidget(items: items, onItemTap: onItemTap),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    );
  }

  /// 使用 GetX 上下文显示，带标题
  static void showByGetWithTitle({String? title, required List<BottomSheetItem> items, void Function(int index)? onItemTap}) {
    Get.bottomSheet(
      _BottomSheetWidget(items: items, onItemTap: onItemTap, title: title),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    );
  }
}

/// 底部菜单项模型
class BottomSheetItem {
  /// 菜单标题
  final String title;

  /// 菜单图标（可选）
  final IconData? icon;

  /// 菜单颜色（可选，默认跟随主题）
  final Color? color;

  const BottomSheetItem({required this.title, this.icon, this.color});
}

/// 底部菜单内部组件
class _BottomSheetWidget extends StatelessWidget {
  final List<BottomSheetItem> items;
  final void Function(int index)? onItemTap;
  final String? title;

  const _BottomSheetWidget({required this.items, this.onItemTap, this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部圆角指示条
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // 标题
            if (title != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            // 菜单项
            if (title != null) const SizedBox(height: 8),
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Get.back();
                      onItemTap?.call(index);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (item.icon != null) ...[
                            Icon(
                              item.icon,
                              color: item.color ?? Colors.grey.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                          ],
                          Flexible(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: item.color ?? Colors.grey.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
