import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_boost/screens/home_screen.dart';
import 'package:mind_boost/screens/onboarding_screen.dart';
import 'package:mind_boost/screens/topic_selection_screen.dart';
import 'package:mind_boost/services/storage_service.dart';
import 'package:mind_boost/theme/app_theme.dart';
import 'package:mind_boost/widgets/custom_illustrations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 3400)); // Slightly increased to match extended choreography
    if (!mounted) return;

    final bool isOnboarded = StorageService.isOnboarded();
    final List<String> selectedTopics = StorageService.getSelectedTopics();

    Widget nextScreen = const OnboardingScreen();
    if (isOnboarded) {
      nextScreen = selectedTopics.isEmpty ? const TopicSelectionScreen() : const HomeScreen();
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 700), // Smoother screen transition
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : Colors.white,
      body: Stack(
        children: [
          // 1. Enhanced Wavy Background Entrance
          if (!isDark)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: _SplashCurveClipper(),
                child: Container(
                  height: screenHeight * 0.55,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE2D9FF), Color(0xFFC7B7FF)],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
            ),
          
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Text Area
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 24.0, right: 24.0),
                  child: Column(
                    children: [
                      // "Interview" title
                      Text(
                        'Interview',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppTheme.lavender : const Color(0xFF3B2F90),
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.15, end: 0, curve: Curves.easeOutBack),
                      
                      // "Buddy" title
                      Text(
                        'Buddy',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppTheme.lavender : const Color(0xFF3B2F90),
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(delay: 150.ms, duration: 500.ms).slideY(begin: -0.15, end: 0, curve: Curves.easeOutBack),
                      
                      const SizedBox(height: 16),
                      
                      // Subtitle
                      Text(
                        'Your daily boost for\ninterview success!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey[400] : AppTheme.grayText,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                    ],
                  ),
                ),

                // 2. High-Impact Owl Illustration with Infinite Idle
                Expanded(
                  child: Center(
                    child: const CuteOwlIllustration(size: 240)
                        .animate()
                        // Impactful Entrance
                        .scale(
                          delay: 500.ms,
                          duration: 800.ms,
                          curve: Curves.elasticOut,
                          begin: const Offset(0.3, 0.3),
                        )
                        .rotate(delay: 500.ms, duration: 800.ms, begin: -0.12, end: 0, curve: Curves.elasticOut)
                        // Infinite subtle breathing/floating effect after entry
                        .then(delay: 800.ms) 
                        .shimmer(duration: 1800.ms, color: Colors.white.withOpacity(0.2))
                        .animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .slideY(duration: 1500.ms, begin: 0, end: 0.04, curve: Curves.easeInOutQuad),
                  ),
                ),

                // Loading Indicator at bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: 35,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isDark ? AppTheme.lavender : const Color(0xFF6C5CE7),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            )
                            .animate(onPlay: (controller) => controller.repeat(reverse: true))
                            .slideX(duration: 1000.ms, begin: -0.1, end: 1.6, curve: Curves.easeInOutSine),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Loading revision cards...',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.grayText,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.05,
      size.width,
      size.height * 0.2,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}