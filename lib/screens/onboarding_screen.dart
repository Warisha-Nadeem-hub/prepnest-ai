import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_boost/screens/topic_selection_screen.dart';
import 'package:mind_boost/services/storage_service.dart';
import 'package:mind_boost/theme/app_theme.dart';
import 'package:mind_boost/widgets/custom_illustrations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Learn. Revise.\nSucceed.',
      description: 'Daily 2-3 minute AI-generated interview cards to help you stay ahead every day.',
      illustration: const CuteOwlIllustration(size: 200),
      type: _IdleAnimationType.float,
    ),
    _OnboardingData(
      title: 'AI-Powered\nRevision Cards',
      description: 'Get concise, structured cards tailored to your chosen interview domains, powered by OpenAI.',
      illustration: const BookIllustration(size: 180),
      type: _IdleAnimationType.swing,
    ),
    _OnboardingData(
      title: 'Build Your\nStreak!',
      description: 'Track your daily study streak and build lasting, consistent revision habits.',
      illustration: const FireIllustration(size: 160),
      type: _IdleAnimationType.pulse,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    await StorageService.setOnboarded(true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => const TopicSelectionScreen(),
        transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Control Action Bar
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 16),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : AppTheme.grayText,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            // Center Content Slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];

                  // FIXED: The ValueKey goes right here on the parent view element to handle page swaps safely
                  return Padding(
                    key: ValueKey<int>(index), 
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Background Ring Circle + Asset Idle Setup
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkSurface : AppTheme.primaryPurpleLight,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: _buildLoopingIllustration(page.illustration, page.type),
                          ),
                        )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.elasticOut, begin: const Offset(0.4, 0.4))
                        .fadeIn(duration: 300.ms),

                        const SizedBox(height: 48),

                        // Choreographed Page Titles
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppTheme.whiteText : AppTheme.darkCharcoal,
                            height: 1.2,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                        const SizedBox(height: 16),

                        // Choreographed Sub-descriptions
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.grey[400] : AppTheme.grayText,
                            height: 1.5,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 350.ms, duration: 400.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Controller Row
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
              child: Column(
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primaryPurple
                              : (isDark ? Colors.grey[700] : Colors.grey[300]),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Primary Interaction Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                          key: ValueKey<bool>(_currentPage == _pages.length - 1),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoopingIllustration(Widget child, _IdleAnimationType type) {
    var baseAnim = child.animate().fadeIn(duration: 400.ms);
    
    switch (type) {
      case _IdleAnimationType.float:
        return baseAnim.then()
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .slideY(duration: 1500.ms, begin: -0.03, end: 0.03, curve: Curves.easeInOutQuad);
      case _IdleAnimationType.swing:
        return baseAnim.then()
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .rotate(duration: 1800.ms, begin: -0.04, end: 0.04, curve: Curves.easeInOutSine);
      case _IdleAnimationType.pulse:
        return baseAnim.then()
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(duration: 1000.ms, begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), curve: Curves.easeInOutQuad);
    }
  }
}

enum _IdleAnimationType { float, swing, pulse }

class _OnboardingData {
  final String title;
  final String description;
  final Widget illustration;
  final _IdleAnimationType type;

  _OnboardingData({
    required this.title,
    required this.description,
    required this.illustration,
    required this.type,
  });
}