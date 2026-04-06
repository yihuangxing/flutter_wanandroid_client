import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/utils/toast_util.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _usernameError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister()  async {
    // 重置错误信息
    setState(() {
      _usernameError = '';
      _passwordError = '';
      _confirmPasswordError = '';
    });

    // 手动校验
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    bool isValid = true;

    if (username.isEmpty) {
      setState(() {
        _usernameError = '请输入用户名';
      });
      isValid = false;
    } else if (username.length < 3) {
      setState(() {
        _usernameError = '用户名长度至少3位';
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

    if (confirmPassword.isEmpty) {
      setState(() {
        _confirmPasswordError = '请确认密码';
      });
      isValid = false;
    } else if (confirmPassword != password) {
      setState(() {
        _confirmPasswordError = '两次输入的密码不一致';
      });
      isValid = false;
    }

    if (isValid) {
          try {
            final result = await ApiService().register(params: {
              'username': username,
              'password': password,
              'repassword': confirmPassword,
            });
            if (result.isSuccess) {
              ToastUtil.showSuccess('注册成功,欢迎回来，$username！');
              RouteUtils.back();
            } else {
              ToastUtil.showError(result.errorMsg);
            }
          } catch (e) {
            ToastUtil.showError(e.toString());
          }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('注册'), centerTitle: true),
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
                    const SizedBox(height: 40),
                    _buildLogo(),
                    const SizedBox(height: 40),
                    _buildUsernameField(),
                    if (_usernameError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_usernameError, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    const SizedBox(height: 15),
                    _buildPasswordField(),
                    if (_passwordError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_passwordError, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    const SizedBox(height: 15),
                    _buildConfirmPasswordField(),
                    if (_confirmPasswordError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_confirmPasswordError, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    const SizedBox(height: 30),
                    _buildRegisterButton(),
                    const SizedBox(height: 20),
                    _buildLoginLink(),
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
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(colors: [Colors.white, Color(0xFFf0f0f0)]),
            // boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset('assets/images/ic_logo.jpg')),
        ),
        const SizedBox(height: 15),
        const Text(
          'WanAndroid',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 4),
        ),
        const SizedBox(height: 8),
        Text('开始您的学习之旅', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
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
            _confirmPasswordError = '';
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

  Widget _buildConfirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        // boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: _confirmPasswordError.isNotEmpty ? Colors.red : Colors.grey[200]!),
      ),
      child: TextField(
        controller: _confirmPasswordController,
        onChanged: (value) {
          setState(() {
            _confirmPasswordError = '';
          });
        },
        obscureText: _obscureConfirmPassword,
        decoration: InputDecoration(
          hintText: '请确认密码',
          prefixIcon: const Icon(Icons.lock, color: Color(0xFF999999)),
          suffixIcon: IconButton(
            icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF999999)),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [Color(0xFFfe4006), Color(0xFFfe4006)]),
        boxShadow: [BoxShadow(color: const Color(0xFFfe4006).withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: MaterialButton(
        onPressed: _handleRegister,
        child: const Text(
          '注 册',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 4),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('已有账号？', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
        TextButton(
          onPressed: () {
            RouteUtils.off('/login');
          },
          child: const Text(
            '立即登录',
            style: TextStyle(color: Color(0xFFfe4006), fontSize: 15, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
