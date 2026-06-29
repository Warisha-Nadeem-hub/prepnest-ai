import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_boost/providers/providers.dart';
import 'package:mind_boost/services/storage_service.dart';
import 'package:mind_boost/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    _apiKeyController.text = ref.read(openAiKeyNotifierProvider);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _saveApiKey() {
    final key = _apiKeyController.text.trim();
    ref.read(openAiKeyNotifierProvider.notifier).setKey(key);
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🔒 OpenAI API Key updated successfully!'),
        backgroundColor: AppTheme.mintDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will delete all cached cards, study notes, streaking scores, and configuration settings. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.clearAll();
              ref.read(openAiKeyNotifierProvider.notifier).setKey('');
              ref.read(selectedTopicsNotifierProvider.notifier).setTopics([]);
              if (!mounted) return;
              Navigator.pop(context);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Data Cleared'),
                  content: const Text(
                    'Your database cache has been wiped out successfully. Please restart the app.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Interview Buddy',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.rocket_launch_rounded,
        color: AppTheme.lavenderDark,
        size: 40,
      ),
      children: [
        const SizedBox(height: 12),
        const Text(
          'Interview Buddy is an AI-powered micro-learning assistant designed to help students and developers prepare for technical interviews. '
          'By generating concise, 2-minute reading cards every day, the app helps build structured, consistent daily study habits.',
        ),
      ],
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'At Interview Buddy, we take privacy seriously:\n\n'
            '1. Local Caching: All cards and notes generated inside this app are saved directly on your local device storage using Hive and are not stored on any remote database.\n\n'
            '2. OpenAI Calls: Tapping "Generate Card" sends the topic name to OpenAI APIs using your configured API key. No personal identifier data or user accounts are sent to OpenAI.\n\n'
            '3. Offline First: Notes, cached reading lists, and configuration settings work 100% offline and do not track any analytics data.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🔗 Share link copied to clipboard! (Demo)'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🌟 Thank you for rating Interview Buddy! (Demo)'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. OpenAI Key Section Card
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF2D3748)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                color: isDark ? AppTheme.darkSurface : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.key_rounded, color: AppTheme.lavenderDark),
                          SizedBox(width: 10),
                          Text(
                            'OpenAI Integration',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Insert your own API key to generate customized AI cards. If empty, the app runs in Demo Mode.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? Colors.grey : AppTheme.grayText,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _apiKeyController,
                        obscureText: _obscureKey,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'sk-proj-...',
                          labelText: 'API Key',
                          prefixIcon: const Icon(
                            Icons.vpn_key_outlined,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureKey
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscureKey = !_obscureKey),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _saveApiKey,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save_rounded, size: 18),
                        label: const Text(
                          'Save API Key',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),

              const SizedBox(height: 24),
              _buildSectionHeader('Preferences', isDark),

              // 2. Preferences List Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: isDark ? AppTheme.darkSurface : Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.dark_mode_outlined,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Switch(
                        value:
                            themeMode == ThemeMode.dark ||
                            (themeMode == ThemeMode.system && isDark),
                        onChanged: (val) {
                          ref
                              .read(themeModeNotifierProvider.notifier)
                              .toggleTheme();
                        },
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 24),
              _buildSectionHeader('General', isDark),
              // 3. General App Submenu Links
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: isDark ? AppTheme.darkSurface : Colors.white,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      Icons.info_outline_rounded,
                      'About App',
                      _showAbout,
                      isDark,
                    ),
                    const Divider(height: 1, indent: 50),
                    _buildSettingsTile(
                      Icons.privacy_tip_outlined,
                      'Privacy Policy',
                      _showPrivacyPolicy,
                      isDark,
                    ),
                    const Divider(height: 1, indent: 50),
                    _buildSettingsTile(
                      Icons.share_outlined,
                      'Share App',
                      _shareApp,
                      isDark,
                    ),
                    const Divider(height: 1, indent: 50),
                    _buildSettingsTile(
                      Icons.star_outline_rounded,
                      'Rate App',
                      _rateApp,
                      isDark,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: 24),
              _buildSectionHeader('Danger Zone', isDark),
              // 4. Wipe Operations Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: isDark ? AppTheme.darkSurface : Colors.white,
                child: _buildSettingsTile(
                  Icons.delete_forever_rounded,
                  'Clear All System Data',
                  _clearCache,
                  isDark,
                  textColor: Colors.red,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.grey : AppTheme.grayText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    VoidCallback onTap,
    bool isDark, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? (isDark ? Colors.grey[400] : AppTheme.grayText),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color:
              textColor ??
              (isDark ? AppTheme.whiteText : AppTheme.darkCharcoal),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: isDark ? Colors.grey[600] : Colors.grey[300],
      ),
      onTap: onTap,
    );
  }
}
