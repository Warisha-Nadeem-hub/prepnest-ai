import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DailyChallengeCard extends StatefulWidget {
  final List<String> selectedTopics;

  const DailyChallengeCard({super.key, required this.selectedTopics});

  @override
  State<DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends State<DailyChallengeCard> {
  bool loading = true;
  Map<String, dynamic>? challenge;

  // Normalization logic to map short forms (e.g. DSA, CN, AI/ML) to match JSON labels
  String normalizeTopic(String name) {
    final cleaned = name.trim().toLowerCase();
    switch (cleaned) {
      case 'dsa':
      case 'data structures':
      case 'data structure':
      case 'algorithms':
        return 'data structures';
      case 'cn':
      case 'computer networks':
      case 'networking':
        return 'computer networks';
      case 'os':
      case 'operating system':
      case 'operating systems':
        return 'operating systems';
      case 'database':
      case 'databases':
      case 'sql':
        return 'databases';
      case 'ai/ml':
      case 'ai':
      case 'ml':
      case 'machine learning':
        return 'ai/ml';
      default:
        return cleaned;
    }
  }

  @override
  void initState() {
    super.initState();
    loadChallenge();
  }

  Future<void> loadChallenge() async {
    setState(() => loading = true);
    try {
      final jsonString = await rootBundle.loadString(
        "lib/assets/challenges.json",
      );
      final List<dynamic> data = json.decode(jsonString);

      // Cleaned Normalized Filter Step
      List<dynamic> filtered = data.where((item) {
        final jsonTopic = normalizeTopic(item["topic"].toString());

        return widget.selectedTopics.any((selected) {
          final userTopic = normalizeTopic(selected);
          return jsonTopic.contains(userTopic) || userTopic.contains(jsonTopic);
        });
      }).toList();

      // FIXED: If nothing matches your active list, fall back to the entire database pool
      if (filtered.isEmpty) {
        filtered = data;
      }

      if (filtered.isNotEmpty) {
        final random = Random();
        setState(() {
          challenge = Map<String, dynamic>.from(
            filtered[random.nextInt(filtered.length)],
          );
          loading = false;
        });
      } else {
        setState(() {
          challenge = null;
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading challenges asset file data stream: $e");
      setState(() {
        challenge = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        ),
      );
    }

    if (challenge == null) {
      return Card(
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 44,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              const Text(
                "No challenges found.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const Text(
                "Make sure assets/challenges.json is registered in pubspec.yaml",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: loadChallenge,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      elevation: 3,
      // Premium background gradient for the challenge card
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E1B4B), const Color(0xFF111827)]
                : [const Color(0xFFFAF5FF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.deepPurple,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Daily Interview Challenge",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                    challenge!["topic"] ?? "General",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: Colors.deepPurple.withOpacity(0.12),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                challenge!["question"] ?? "",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: isDark
                      ? const Color(0xFFF1F5F9)
                      : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  iconColor: Colors.deepPurple,
                  collapsedIconColor: Colors.deepPurple,
                  title: const Text(
                    "Reveal Answer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      fontSize: 15,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 4),
                      child: Text(
                        challenge!["answer"] ?? "",
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 14,
                          // FIX: Forced high-contrast readable colors for both light and dark themes
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF334155),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // FIX: Wrapped with a row that matches content size instead of fracturing text boundaries
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 48, // Compact height to fit text perfectly
                      child: ElevatedButton.icon(
                        onPressed: loadChallenge,
                        icon: const Icon(Icons.skip_next_rounded, size: 18),
                        // FIX: Reduced padding/font size to ensure 'Next' never wraps vertically
                        label: const Text(
                          "Next",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 0.3,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.deepPurple.withOpacity(0.3),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pinned challenge to study list!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.note_add_rounded, size: 18),
                        // FIX: Reduced padding/font size to ensure 'Save' never wraps vertically
                        label: const Text(
                          "Save",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 0.3,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.deepPurple,
                            width: 1.5,
                          ),
                          foregroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
