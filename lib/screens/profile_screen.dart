import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_boost/providers/providers.dart';
import 'package:mind_boost/screens/settings_screen.dart';
import 'package:mind_boost/screens/topic_selection_screen.dart';
import 'package:mind_boost/theme/app_theme.dart';
import 'package:mind_boost/widgets/custom_illustrations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streak = ref.watch(streakNotifierProvider);
    final notes = ref.watch(notesNotifierProvider);
    final selectedTopics = ref.watch(selectedTopicsNotifierProvider);

    // Hardcoded static value or bind with card histories provider if available
    const totalCardsRead = 30;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile header with owl
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppTheme.primaryPurple.withAlpha(40),
                            AppTheme.darkSurface,
                          ]
                        : [AppTheme.primaryPurpleLight, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF2D3748)
                        : Colors.grey.shade200,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Floating Owl avatar
                    Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkSurface : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryPurple.withAlpha(30),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: CuteOwlIllustration(size: 80),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(
                          begin: -4,
                          end: 4,
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                        )
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 16),
                    Text(
                      'Hey, Buddy!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppTheme.whiteText
                            : AppTheme.darkCharcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Keep learning every day!',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : AppTheme.grayText,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),

              // Stats row
              Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.whiteText : AppTheme.darkCharcoal,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                    children: [
                      _buildStatBox(
                        context,
                        value: '$totalCardsRead',
                        label: 'Cards Read',
                        color: AppTheme.primaryPurple,
                        bgColor: isDark
                            ? AppTheme.primaryPurple.withAlpha(25)
                            : AppTheme.primaryPurpleLight,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      _buildStatBox(
                        context,
                        value: '${notes.length}',
                        label: 'Notes Created',
                        color: AppTheme.lightBlueDark,
                        bgColor: isDark
                            ? AppTheme.lightBlueDark.withAlpha(25)
                            : AppTheme.lightBlueLight,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      _buildStatBox(
                        context,
                        value: '$streak',
                        label: 'Day Streak',
                        color: AppTheme.peachDark,
                        bgColor: isDark
                            ? AppTheme.peachDark.withAlpha(25)
                            : AppTheme.peachLight,
                        isDark: isDark,
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 400.ms)
                  .slideY(begin: 0.05, end: 0),
              const SizedBox(height: 24),

              // Menu items with individual index stagger delays
              _buildMenuItem(
                context,
                index: 0,
                icon: Icons.topic_rounded,
                iconColor: AppTheme.primaryPurple,
                title: 'Topics',
                subtitle: '${selectedTopics.length} domains selected',
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TopicSelectionScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                index: 1,
                icon: Icons.bookmark_outline_rounded,
                iconColor: AppTheme.lightBlueDark,
                title: 'Bookmarks',
                subtitle: 'Saved cards & topics',
                isDark: isDark,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bookmarks layout coming soon!'),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                index: 2,
                icon: Icons.emoji_events_outlined,
                iconColor: AppTheme.peachDark,
                title: 'Achievements',
                subtitle: 'Badges & milestones',
                isDark: isDark,
                onTap: () => _showAchievementsSheet(
                  context,
                  streak,
                  notes.length,
                  totalCardsRead,
                  isDark,
                ),
              ),
              _buildMenuItem(
                context,
                index: 3,
                icon: Icons.bar_chart_rounded,
                iconColor: AppTheme.mintDark,
                title: 'Statistics',
                subtitle: 'Track study analytics',
                isDark: isDark,
                onTap: () => _showStatisticsSheet(
                  context,
                  selectedTopics,
                  totalCardsRead,
                  isDark,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context, {
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2D3748) : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : AppTheme.grayText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF2D3748) : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.whiteText
                            : AppTheme.darkCharcoal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey : AppTheme.grayText,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.grey : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (200 + (index * 60)).ms).moveX(begin: 16, end: 0);
  }

  // --- ACTIONS SYSTEM: ACHIEVEMENT PANEL ---
  void _showAchievementsSheet(
    BuildContext context,
    int streak,
    int notesCount,
    int totalCards,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1A202C) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Unlocked Badges',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _buildBadgeCard(
                      'First Step',
                      'Read 1st card',
                      totalCards >= 1,
                      Icons.bolt,
                      Colors.amber,
                    ),
                    _buildBadgeCard(
                      'Consistency King',
                      '3 Day Streak',
                      streak >= 3,
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                    _buildBadgeCard(
                      'Note Taker',
                      'Created a note',
                      notesCount >= 1,
                      Icons.edit_note,
                      Colors.blue,
                    ),
                    _buildBadgeCard(
                      'Scholar Status',
                      'Read 30 cards',
                      totalCards >= 30,
                      Icons.school,
                      Colors.purple,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadgeCard(
    String name,
    String rule,
    bool isUnlocked,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? color.withOpacity(0.1)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? color.withOpacity(0.4) : Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isUnlocked ? color : Colors.grey, size: 28),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? color : Colors.grey,
            ),
          ),
          Text(
            rule,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  } // --- ACTIONS SYSTEM: ANALYTICS STATISTICS PANEL ---

  void _showStatisticsSheet(
    BuildContext context,
    List<String> topics,
    int totalCards,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1A202C) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Domain Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Distribution across $totalCards total answers.',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              if (topics.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No active study domains found.'),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: topics.length,
                  // FIX: Changed from (, __) to (_, __)
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    // Distribute synthetic dummy percentages dynamically for UI presentation
                    double fills = (idx == 0)
                        ? 0.7
                        : (idx == 1)
                        ? 0.45
                        : 0.2;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              topics[idx],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${(fills * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: fills,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryPurple,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
