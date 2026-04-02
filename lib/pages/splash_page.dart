// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  _SplashpageState createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToMainPage();
  }

  void _initAnimations() {
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _animationController.forward();
  }

  void _navigateToMainPage() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        RouteUtils.off(Routes.main);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildLogo(), const SizedBox(height: 32), _buildAppName(), const SizedBox(height: 48), _buildLoadingIndicator()],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFf0f0f0),
        borderRadius: BorderRadius.circular(60),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: ClipOval(child: Image.asset('assets/images/ic_logo.jpg', fit: BoxFit.cover)),
    );
  }

  Widget _buildAppName() {
    return const Column(
      children: [
        Text(
          'WanAndroid',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333), letterSpacing: 2),
        ),
        SizedBox(height: 8),
        Text('玩安卓客户端', style: TextStyle(fontSize: 16, color: Color(0xFF666666), letterSpacing: 1)),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
        backgroundColor: const Color(0xFFf0f0f0),
      ),
    );
  }
}
