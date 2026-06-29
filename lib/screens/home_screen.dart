import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_boost/models/learning_card.dart';
import 'package:mind_boost/providers/providers.dart';
import 'package:mind_boost/screens/learning_card_screen.dart';
import 'package:mind_boost/screens/notes_screen.dart';
import 'package:mind_boost/screens/reminder_screen.dart';
import 'package:mind_boost/screens/settings_screen.dart';
import 'package:mind_boost/screens/profile_screen.dart';
import 'package:mind_boost/theme/app_theme.dart';
import 'package:mind_boost/utils/app_constants.dart';
import 'package:mind_boost/widgets/custom_illustrations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  String _selectedTopic = '';

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ✨';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }

  void _triggerCardGeneration(String topic, {bool force = false}) {
    ref
        .read(cardNotifierProvider.notifier)
        .fetchCard(topic, forceGenerate: force);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTopics = ref.watch(selectedTopicsNotifierProvider);

    if (_selectedTopic.isEmpty && selectedTopics.isNotEmpty) {
      _selectedTopic = selectedTopics.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerCardGeneration(_selectedTopic);
      });
    }

    final screens = [
      _buildDashboard(context, selectedTopics, isDark),
      const NotesScreen(),
      const ReminderScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2_outlined),
            selectedIcon: Icon(Icons.sticky_note_2_rounded),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none_rounded),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Reminders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    List<String> selectedTopics,
    bool isDark,
  ) {
    final streak = ref.watch(streakNotifierProvider);
    final cardState = ref.watch(cardNotifierProvider);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (_selectedTopic.isNotEmpty) {
              _triggerCardGeneration(_selectedTopic, force: true);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Greeting + Settings icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.grey[400]
                                : AppTheme.grayText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Keep going, keep growing!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppTheme.whiteText
                                : AppTheme.darkCharcoal,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF2D3748)
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Icon(
                          Icons.settings_outlined,
                          color: isDark ? Colors.grey[400] : AppTheme.grayText,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 20),

                // Stats row - Streak + Cards Completed
                Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.local_fire_department_rounded,
                            iconColor: AppTheme.peachDark,
                            iconBgColor: isDark
                                ? AppTheme.peachDark.withAlpha(30)
                                : AppTheme.peachLight,
                            value: '$streak',
                            label: 'Day Streak',
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.auto_stories_rounded,
                            iconColor: AppTheme.primaryPurple,
                            iconBgColor: isDark
                                ? AppTheme.primaryPurple.withAlpha(30)
                                : AppTheme.primaryPurpleLight,
                            value: '12/30',
                            label: 'Cards Solved',
                            isDark: isDark,
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 400.ms)
                    .slideY(begin: 0.05, end: 0),
                const SizedBox(height: 15),

                // Completed Implementation of Topic Selector Chips
                if (selectedTopics.isNotEmpty) ...[
                  SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedTopics.length,
                      itemBuilder: (context, index) {
                        final topic = selectedTopics[index];
                        final isSelected = _selectedTopic == topic;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              topic,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                          ? Colors.grey
                                          : AppTheme.darkCharcoal),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedTopic = topic);
                                _triggerCardGeneration(topic);
                              }
                            },
                            selectedColor: AppTheme.primaryPurple,
                            backgroundColor: isDark
                                ? AppTheme.darkSurface
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Premium Dynamic AI Card Architecture Loader with precise null safeguards
                cardState.when(
                  data: (card) {
                    if (card == null) {
                      return _buildEmptyStatePlaceholder(isDark);
                    }
                    return _buildMainCard(context, card, isDark)
                        .animate(key: ValueKey(card.id ?? 'default_id'))
                        .fadeIn(duration: 450.ms)
                        .slideY(
                          begin: 0.08,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        );
                  },
                  loading: () => _buildCardLoadingPlaceholder(isDark),
                  error: (err, _) =>
                      _buildCardErrorPlaceholder(isDark, err.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ), // Made slightly tighter for small screens
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ), // Scaled down icon slightly
          ),
          const SizedBox(width: 10),
          // FIX: Wrapped Column with Expanded to enforce constraints and auto-wrap text bounds
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize
                  .min, // Prevents vertical sizing expansion conflicts
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow
                      .ellipsis, // Adds ... if text value is too long
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 2, // Allows text wrapping to prevent overflows
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey : AppTheme.grayText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, LearningCard card, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF311042)]
              : [const Color(0xFFFAF5FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppTheme.primaryPurple.withOpacity(0.3)
              : AppTheme.primaryPurpleLight,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(isDark ? 0.15 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: AppTheme.primaryPurple.withOpacity(0.06),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: AppTheme.primaryPurple,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'AI DAILY CARD',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primaryPurple,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Interactive Mini Regenerate Button
                      IconButton(
                        icon: const Icon(
                          Icons.refresh_rounded,
                          size: 20,
                          color: AppTheme.primaryPurple,
                        ),
                        tooltip: 'Generate New Card',
                        onPressed: () =>
                            _triggerCardGeneration(_selectedTopic, force: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    card.title,
                    // Fixed data alignment binding
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      color: isDark
                          ? AppTheme.whiteText
                          : AppTheme.darkCharcoal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap below to see the complete revision notes.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: isDark ? Colors.grey : AppTheme.grayText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LearningCardScreen(card: card),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: AppTheme.primaryPurple.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Reveal Flashcard',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
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

  Widget _buildCardLoadingPlaceholder(bool isDark) {
    return Container(
          height: 240,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryPurple,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Consulting Interview Buddy AI...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey : AppTheme.grayText,
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1500.ms,
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        );
  }

  Widget _buildCardErrorPlaceholder(bool isDark, String error) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D1F23) : const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Generation Suspended',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            error.contains('API')
                ? 'Please inspect your OpenAI network security token configurations in settings.'
                : error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: isDark ? Colors.grey : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStatePlaceholder(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome_motion_rounded,
            size: 48,
            color: AppTheme.primaryPurple,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Card Available',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () =>
                _triggerCardGeneration(_selectedTopic, force: true),
            child: const Text('Generate Initial Card'),
          ),
        ],
      ),
    );
  }
}
