import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/utils/storage_util.dart';
import 'package:flutter_wanandroid_client/utils/toast_util.dart';
import 'package:get/get.dart';

/// 隐私政策弹窗组件
///
/// 功能特性：
/// 1. 在App首次启动时自动显示
/// 2. 使用RichText展示隐私政策内容，支持可点击链接
/// 3. 包含"同意"和"不同意"按钮
/// 4. 适配不同屏幕尺寸
/// 5. 完整的错误处理机制
class PrivacyPolicyDialog {
  /// 隐私政策已同意的存储key
  static const String _agreedKey = 'privacy_policy_agreed';

  /// 检查用户是否已同意隐私政策
  static bool hasAgreed() {
    try {
      return StorageUtil.getBool(_agreedKey) ?? false;
    } catch (e) {
      debugPrint('检查隐私政策同意状态失败: $e');
      return false;
    }
  }

  /// 保存用户同意状态
  static Future<void> _saveAgreed(bool agreed) async {
    try {
      await StorageUtil.setBool(_agreedKey, agreed);
    } catch (e) {
      debugPrint('保存隐私政策同意状态失败: $e');
      ToastUtil.show('保存状态失败');
    }
  }

  /// 显示隐私政策弹窗
  ///
  /// [onAgree] - 用户同意后的回调
  /// [onDisagree] - 用户不同意后的回调，默认退出应用
  static Future<void> show({Function()? onAgree, Function()? onDisagree}) async {
    try {
      await Get.dialog(
        // 缓入缓出 - 两端慢，中间快
        transitionCurve: Curves.easeInOut,
        // 缓出 - 开始快，后面慢（最自然）
        //transitionCurve: Curves.easeOut,
        //  缓入 - 开始慢，后面快
        //transitionCurve: Curves.easeIn,
        // 线性动画 - 匀速
        //transitionCurve: Curves.linear,
        transitionDuration: const Duration(milliseconds: 800),
        _PrivacyPolicyContent(
          onAgree: () async {
            await _saveAgreed(true);
            Get.back();
          },
          onDisagree: () async {
            await _saveAgreed(false);
            Get.back();
          },
        ),
        barrierDismissible: false,
      );

      // 弹窗关闭后检查用户是否同意
      if (hasAgreed()) {
        onAgree?.call();
      } else {
        onDisagree?.call() ?? _defaultDisagreeAction();
      }
    } catch (e) {
      debugPrint('显示隐私政策弹窗失败: $e');
      ToastUtil.show('加载隐私政策失败');
    }
  }

  /// 默认的不同意操作 - 退出应用
  static void _defaultDisagreeAction() {
    try {
      ToastUtil.show('请同意隐私政策以使用应用');
      Future.delayed(const Duration(seconds: 1), () {
        // RouteUtils.back();
      });
    } catch (e) {
      debugPrint('执行不同意操作失败: $e');
    }
  }
}

/// 隐私政策弹窗内容组件
class _PrivacyPolicyContent extends StatefulWidget {
  final VoidCallback onAgree;
  final VoidCallback onDisagree;

  const _PrivacyPolicyContent({required this.onAgree, required this.onDisagree});

  @override
  State<_PrivacyPolicyContent> createState() => _PrivacyPolicyContentState();
}

class _PrivacyPolicyContentState extends State<_PrivacyPolicyContent> {
  /// 是否同意隐私政策
  bool _isAgreed = true;

  /// 手势识别器
  TapGestureRecognizer? _privacyPolicyRecognizer;
  TapGestureRecognizer? _userAgreementRecognizer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _privacyPolicyRecognizer?.dispose();
    _userAgreementRecognizer?.dispose();
    super.dispose();
  }

  /// 获取隐私政策手势识别器
  TapGestureRecognizer _getPrivacyPolicyRecognizer() {
    _privacyPolicyRecognizer ??= TapGestureRecognizer()..onTap = _openPrivacyPolicy;
    return _privacyPolicyRecognizer!;
  }

  /// 获取用户协议手势识别器
  TapGestureRecognizer _getUserAgreementRecognizer() {
    _userAgreementRecognizer ??= TapGestureRecognizer()..onTap = _openUserAgreement;
    return _userAgreementRecognizer!;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: SizedBox(
          width: double.infinity,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 标题区域
                  _buildTitle(),
                  const SizedBox(height: 20),

                  // 内容区域
                  _buildContent(context),
                  const SizedBox(height: 10),

                  // 同意勾选框
                  // _buildAgreeCheckbox(),
                  const SizedBox(height: 24),

                  // 按钮区域
                  _buildButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建标题
  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 24),
      child: Text(
        '隐私政策',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  /// 构建内容区域
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
              children: [
                const TextSpan(text: '欢迎使用 WanAndroid 客户端！\n'),
                const TextSpan(text: '我们非常重视保护您的个人信息和隐私。您可以通过'),
                _buildLinkText('《隐私政策》', _getPrivacyPolicyRecognizer()),
                const TextSpan(text: '和'),
                _buildLinkText('《用户协议》', _getUserAgreementRecognizer()),
                const TextSpan(text: '了解我们收集、使用、存储用户个人信息的情况，以及您所享有的相关权利。\n请您仔细阅读并充分理解相关内容：\n1.为向您提供游戏服务，我们将依据'),
                _buildLinkText('《隐私政策》', _getPrivacyPolicyRecognizer()),
                const TextSpan(text: '收集、使用、存储必要的信息。'),
                const TextSpan(text: '\n2. 基于您的明示授权，我们可能会申请开启您的设备权限，您有权拒绝或取消授权。'),
                const TextSpan(text: '\n3. 我们会采取业界先进的安全措施保护您的信息安全。'),
                const TextSpan(text: '\n4. 未经您同意，我们不会从第三方处获取、共享或向其提供您的信息。'),
                const TextSpan(text: '\n5. 您可以查询、更正、删除您的个人信息，我们也提供账号注销的渠道。'),
                const TextSpan(text: '\n\n'),
                const TextSpan(text: '请您认真阅读上述协议内容。如果您同意，请勾选下方选项并点击"同意"按钮。'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建可点击的链接文本
  TextSpan _buildLinkText(String text, TapGestureRecognizer recognizer) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      recognizer: recognizer,
    );
  }

  /// 打开隐私政策页面
  void _openPrivacyPolicy() {
    ToastUtil.show('正在打开隐私政策...');
  }

  /// 打开用户协议页面
  void _openUserAgreement() {
    ToastUtil.show('正在打开用户协议...');
  }

  /// 构建同意勾选框
  Widget _buildAgreeCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _isAgreed,
            onChanged: (value) {
              setState(() {
                _isAgreed = value ?? false;
              });
            },
            activeColor: Colors.red,
            checkColor: Colors.white,
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 15),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  children: [
                    const TextSpan(text: '我已阅读并同意'),
                    _buildLinkText('《隐私政策》', _getPrivacyPolicyRecognizer()),
                    const TextSpan(text: '和'),
                    _buildLinkText('《用户协议》', _getUserAgreementRecognizer()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建按钮区域
  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // 不同意按钮
          Expanded(
            child: _buildButton(text: '不同意', isPrimary: false, onTap: widget.onDisagree),
          ),
          const SizedBox(width: 12),

          // 同意按钮
          Expanded(
            child: _buildButton(text: '同意', isPrimary: true, onTap: _isAgreed ? widget.onAgree : null),
          ),
        ],
      ),
    );
  }

  /// 构建按钮
  Widget _buildButton({required String text, required bool isPrimary, Function()? onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: onTap != null ? (isPrimary ? Colors.red : Colors.grey.shade100) : Colors.grey.shade200,
        foregroundColor: onTap != null ? (isPrimary ? Colors.white : Colors.black87) : Colors.grey.shade400,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
        minimumSize: const Size(double.infinity, 45),
        elevation: 0,
        side: isPrimary ? null : BorderSide(color: Colors.grey.shade300),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal)),
    );
  }
}
