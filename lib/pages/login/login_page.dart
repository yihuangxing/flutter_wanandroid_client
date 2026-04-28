import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/pages/login/controller/user_controller.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/storage_util.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _usernameError = '';
  String _passwordError = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _rememberPassword = false;
  String _currentUsername = '';
  String _currentPassword = '';

  UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward();
    // 初始化记住密码状态
    _rememberPassword = StorageUtil.getBool(StorageKey.loginRememberPassword) ?? false;
    if (_rememberPassword) {
      _currentUsername = StorageUtil.getString(StorageKey.loginUsername) ?? '';
      _currentPassword = StorageUtil.getString(StorageKey.loginPassword) ?? '';
      if (_currentUsername.isNotEmpty && _currentPassword.isNotEmpty) {
        _usernameController.text = _currentUsername;
        _passwordController.text = _currentPassword;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // 重置错误信息
    setState(() {
      _usernameError = '';
      _passwordError = '';
    });

    // 手动校验
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    bool isValid = true;

    if (username.isEmpty) {
      setState(() {
        _usernameError = '请输入用户名';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = '请输入密码';
      });
      isValid = false;
    } else if (password.length < 6) {
      setState(() {
        _passwordError = '密码长度至少6位';
      });
      isValid = false;
    }
    if (isValid) {
      await userController.login(username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录'), centerTitle: true),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    _buildLogo(),
                    const SizedBox(height: 50),
                    _buildUsernameField(),
                    if (_usernameError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_usernameError, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                    if (_passwordError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_passwordError, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    const SizedBox(height: 10),
                    _buildForgotPassword(),
                    const SizedBox(height: 30),
                    _buildLoginButton(),
                    const SizedBox(height: 20),
                    _buildRegisterLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(colors: [Colors.white, Color(0xFFf0f0f0)]),
            // boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5)],
          ),
          child: ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.asset('assets/images/ic_logo.jpg')),
        ),
        const SizedBox(height: 20),
        const Text(
          'WanAndroid',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 4),
        ),
        const SizedBox(height: 8),
        Text('登录您的账户', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        // boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: _usernameError.isNotEmpty ? Colors.red : Colors.grey[200]!),
      ),
      child: TextField(
        controller: _usernameController,
        onChanged: (value) {
          setState(() {
            _usernameError = '';
          });
        },
        decoration: const InputDecoration(
          hintText: '请输入用户名',
          prefixIcon: Icon(Icons.person, color: Color(0xFF999999)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        // boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: _passwordError.isNotEmpty ? Colors.red : Colors.grey[200]!),
      ),
      child: TextField(
        controller: _passwordController,
        onChanged: (value) {
          setState(() {
            _passwordError = '';
          });
        },
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: '请输入密码',
          prefixIcon: const Icon(Icons.lock, color: Color(0xFF999999)),
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF999999)),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Row(
      children: [
        Row(
          children: [
            Checkbox(
              fillColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected) ? Color(0xFFfe4006) : Colors.grey[200]!,
              ),
              value: _rememberPassword,
              onChanged: (value) {
                StorageUtil.setBool(StorageKey.loginRememberPassword, value ?? false);
                setState(() {
                  _rememberPassword = value ?? false;
                });
              },
            ),
            Text("记住密码", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text("忘记密码？", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [Color(0xFFFF6A00), Color(0xFFfe4006)]),
        boxShadow: [BoxShadow(color: const Color(0xFFfe4006).withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: MaterialButton(
        onPressed: _handleLogin,
        child: const Text(
          '登 录',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 4),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('还没有账号？', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
        TextButton(
          onPressed: () {
            RouteUtils.to(Routes.register);
          },
          child: const Text(
            '立即注册',
            style: TextStyle(
              color: Color(0xFFFF6A00),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
