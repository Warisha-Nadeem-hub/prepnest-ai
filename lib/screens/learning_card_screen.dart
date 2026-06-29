import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_boost/models/learning_card.dart';
import 'package:mind_boost/providers/providers.dart';
import 'package:mind_boost/theme/app_theme.dart';
import 'package:mind_boost/utils/app_constants.dart';

class LearningCardScreen extends ConsumerStatefulWidget {
  final LearningCard card;
  const LearningCardScreen({super.key, required this.card});

  @override
  ConsumerState<LearningCardScreen> createState() => _LearningCardScreenState();
}

class _LearningCardScreenState extends ConsumerState<LearningCardScreen> {
  bool _showAnswer = false;
  bool _isRead = false;

  void _onMarkAsRead() {
    setState(() => _isRead = true);
    ref.read(streakNotifierProvider.notifier).markCardRead();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.celebration_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Great job! Streak updated!'),
          ],
        ),
        backgroundColor: AppTheme.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Topic badge
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.primaryPurple.withAlpha(30) : AppTheme.primaryPurpleLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppConstants.getDomainIcon(widget.card.topic),
                    size: 14, color: AppTheme.primaryPurple),
                const SizedBox(width: 6),
                Text(widget.card.topic, style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryPurple,
                )),
              ],
            ),
          ),
          // Reading time
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule_rounded, size: 14,
                    color: isDark ? Colors.grey[400] : AppTheme.grayText),
                const SizedBox(width: 4),
                Text(widget.card.readingTime, style: TextStyle(
                  fontSize: 12, color: isDark ? Colors.grey[400] : AppTheme.grayText,
                )),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                widget.card.title,
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, height: 1.3,
                  color: isDark ? AppTheme.whiteText : AppTheme.darkCharcoal,
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: 16),

              // Explanation
              Text(
                widget.card.explanation,
                style: TextStyle(
                  fontSize: 15, height: 1.7,
                  color: isDark ? Colors.grey[300] : AppTheme.darkCharcoal.withAlpha(200),
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 24),

              // Key Points
              Text('Key Points', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.whiteText : AppTheme.darkCharcoal,
              )).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              ...widget.card.bulletPoints.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryPurple,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(entry.value, style: TextStyle(
                          fontSize: 14, height: 1.5,
                          color: isDark ? Colors.grey[300] : AppTheme.darkCharcoal,
                        )),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (250 + entry.key * 50).ms, duration: 300.ms);
              }),
              const SizedBox(height: 24),

              // Interview Question Section
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? const Color(0xFF2D3748) : Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.primaryPurple.withAlpha(30) : AppTheme.primaryPurpleLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.quiz_rounded, color: AppTheme.primaryPurple, size: 18),
                        ),
                        const SizedBox(width: 10),
                        const Text('Interview Question', style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15,
                        )),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(widget.card.interviewQuestion, style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.whiteText : AppTheme.darkCharcoal,
                    )),
                    const SizedBox(height: 14),
                    if (_showAnswer) ...[
                      Divider(color: isDark ? const Color(0xFF2D3748) : Colors.grey.shade200),
                      const SizedBox(height: 10),
                      Text('Sample Answer:', style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12,
                        color: isDark ? Colors.grey[400] : AppTheme.grayText,
                      )),
                      const SizedBox(height: 6),
                      Text(widget.card.sampleAnswer, style: TextStyle(
                        fontSize: 14, height: 1.6,
                        color: isDark ? Colors.grey[300] : AppTheme.darkCharcoal,
                      )).animate().fadeIn(duration: 300.ms),
                    ],
                    const SizedBox(height: 14),
                    OutlinedButton(
                      onPressed: () => setState(() => _showAnswer = !_showAnswer),
                      child: Text(_showAnswer ? 'Hide Answer' : 'Show Answer'),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
              const SizedBox(height: 16),

              // Quick Tip
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.peachDark.withAlpha(20) : AppTheme.peachLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppTheme.peachDark.withAlpha(40) : AppTheme.peach),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_rounded, color: AppTheme.peachDark, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quick Tip', style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13,
                            color: isDark ? AppTheme.peach : AppTheme.peachDark,
                          )),
                          const SizedBox(height: 4),
                          Text(widget.card.quickTip, style: TextStyle(
                            fontSize: 13, height: 1.4,
                            color: isDark ? Colors.grey[300] : AppTheme.darkCharcoal,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 24),

              // Bottom action buttons matching mockup 5
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.edit_note_rounded, size: 18),
                        label: const Text('Take Notes'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        icon: Icon(_isRead ? Icons.check_circle_rounded : Icons.bookmark_add_rounded, size: 18),
                        label: Text(_isRead ? 'Saved!' : 'Save Card'),
                        onPressed: _isRead ? null : _onMarkAsRead,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRead ? AppTheme.mintDark : AppTheme.primaryPurple,
                          disabledBackgroundColor: AppTheme.mintDark.withAlpha(180),
                          disabledForegroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
