import 'package:flutter/material.dart';
import 'student_list_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  String fullText = "Welcome to your Student Tracker!";
  String displayedText = "";
  int textIndex = 0;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Bounce animation for icon
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Typing text effect
    _startTypingEffect();
  }

  void _startTypingEffect() async {
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (mounted) {
        setState(() {
          textIndex = i + 1;
          displayedText = fullText.substring(0, textIndex);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const StudentListPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade700,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Animated bouncing icon
          ScaleTransition(
            scale: _scaleAnimation,
            child: const Icon(
              Icons.school_rounded,
              size: 100,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Animated title text
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 2),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Padding(
                  padding: EdgeInsets.only(top: value * 10),
                  child: child,
                ),
              );
            },
            child: const Text(
              "Student Manager",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Typing effect text
          Text(
            displayedText,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),

          const Spacer(),

          // Animated button with slide + fade
         Padding(
  padding: const EdgeInsets.all(16.0),
  child: TweenAnimationBuilder<double>(
    duration: const Duration(seconds: 2),
    curve: Curves.easeOutBack,
    tween: Tween(begin: 50.0, end: 0.0),
    builder: (context, value, child) {
      return Transform.translate(
        offset: Offset(0, value),
        child: Opacity(
          opacity: ((50 - value) / 50).clamp(0.0, 1.0),
          child: child,
        ),
      );
    },
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.arrow_forward_ios, size: 18),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _navigateToHome,
        label: const Text(
          "Get Started",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ),
),

        ],
      ),
    );
  }
}
