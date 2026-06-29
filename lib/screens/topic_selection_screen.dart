import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_boost/providers/providers.dart';
import 'package:mind_boost/screens/home_screen.dart';
import 'package:mind_boost/theme/app_theme.dart';
import 'package:mind_boost/utils/app_constants.dart';

class TopicSelectionScreen extends ConsumerWidget {
  const TopicSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopics = ref.watch(selectedTopicsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Your\nInterview Domains',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppTheme.whiteText : AppTheme.darkCharcoal,
                      height: 1.2,
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    'Select one or more topics you want to focus on',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : AppTheme.grayText,
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Grid of domains
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
                itemCount: AppConstants.domains.length,
                itemBuilder: (context, index) {
                  final domain = AppConstants.domains[index];
                  final isSelected = selectedTopics.contains(domain.name);
                  final accentColor = AppConstants.getDomainAccentColor(domain.name);

                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedTopicsNotifierProvider.notifier).toggleTopic(domain.name);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryPurple
                            : (isDark ? AppTheme.darkSurface : Colors.white),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryPurple
                              : (isDark ? const Color(0xFF2D3748) : Colors.grey.shade200),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryPurple.withAlpha(60),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon circle
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withAlpha(50)
                                  : (isDark
                                      ? accentColor.withAlpha(30)
                                      : AppConstants.getDomainColor(domain.name)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              domain.icon,
                              size: 24,
                              color: isSelected ? Colors.white : accentColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            domain.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppTheme.whiteText : AppTheme.darkCharcoal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().scale(
                        delay: (index * 30).ms,
                        duration: 300.ms,
                        begin: const Offset(0.9, 0.9),
                      );
                },
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedTopics.isNotEmpty
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                    disabledForegroundColor: Colors.grey[500],
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
