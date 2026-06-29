import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_boost/providers/providers.dart';
import 'package:mind_boost/theme/app_theme.dart';

class ReminderScreen extends ConsumerWidget {
  const ReminderScreen({super.key});

  void _selectCustomTime(BuildContext context, WidgetRef ref, int currentHour, int currentMinute) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppTheme.primaryPurple),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      ref.read(reminderSettingsNotifierProvider.notifier).setCustomTime(picked.hour, picked.minute);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(reminderSettingsNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final frequencies = ['Once Daily', 'Twice Daily', 'Three Times Daily', 'Custom'];

    final hourOfPeriod = settings.hour > 12 ? settings.hour - 12 : (settings.hour == 0 ? 12 : settings.hour);
    final period = settings.hour >= 12 ? 'PM' : 'AM';
    final formattedTime = '$hourOfPeriod:${settings.minute.toString().padLeft(2, '0')} $period';

    // Pre-configured times for different frequencies
    List<String> reminderTimes = [];
    switch (settings.frequency.toLowerCase()) {
      case 'once daily':
        reminderTimes = [formattedTime];
        break;
      case 'twice daily':
        reminderTimes = ['9:00 AM', '6:00 PM'];
        break;
      case 'three times daily':
        reminderTimes = ['9:00 AM', '2:00 PM', '8:00 PM'];
        break;
      default:
        reminderTimes = [formattedTime];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main toggle card
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? const Color(0xFF2D3748) : Colors.grey.shade200),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Enable Reminders', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(
                          'Get daily nudges to remind you!',
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : AppTheme.grayText),
                        ),
                      ],
                    ),
                    Switch(
                      value: settings.isEnabled,
                      onChanged: (val) => ref.read(reminderSettingsNotifierProvider.notifier).toggleEnabled(val),
                      activeColor: AppTheme.primaryPurple,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              if (settings.isEnabled) ...[
                // Frequency section
                const Text('Choose Frequency', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 12),
                ...frequencies.map((freq) {
                  final isSelected = settings.frequency.toLowerCase() == freq.toLowerCase();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryPurple : (isDark ? const Color(0xFF2D3748) : Colors.grey.shade200),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: RadioListTile<String>(
                      title: Text(freq, style: TextStyle(
                        fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      )),
                      value: freq.toLowerCase(),
                      groupValue: settings.frequency.toLowerCase(),
                      activeColor: AppTheme.primaryPurple,
                      onChanged: (val) {
                        if (val != null) ref.read(reminderSettingsNotifierProvider.notifier).setFrequency(val);
                      },
                      visualDensity: VisualDensity.compact,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  );
                }).toList().animate(interval: 60.ms).fadeIn(duration: 250.ms).slideY(begin: 0.05, end: 0),
                const SizedBox(height: 20),

                // Reminder Time section
                const Text('Reminder Time', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 12),
                ...reminderTimes.asMap().entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? const Color(0xFF2D3748) : Colors.grey.shade200),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.primaryPurple.withAlpha(30) : AppTheme.primaryPurpleLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.access_time_rounded, color: AppTheme.primaryPurple, size: 20),
                      ),
                      title: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.grayText),
                      onTap: () => _selectCustomTime(context, ref, settings.hour, settings.minute),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList().animate(interval: 60.ms).fadeIn(delay: 200.ms, duration: 250.ms),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
