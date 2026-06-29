import 'package:flutter/material.dart';
import 'package:mind_boost/theme/app_theme.dart';

class DomainItem {
  final String name;
  final IconData icon;
  final String desc;

  const DomainItem({
    required this.name,
    required this.icon,
    required this.desc,
  });
}

class AppConstants {
  static const List<DomainItem> domains = [
    DomainItem(name: 'Flutter', icon: Icons.flutter_dash, desc: 'Cross-platform app development'),
    DomainItem(name: 'Android', icon: Icons.android, desc: 'Native Android system & dev'),
    DomainItem(name: 'Java', icon: Icons.coffee, desc: 'Java programming & JVM'),
    DomainItem(name: 'Python', icon: Icons.code, desc: 'Python & scripting concepts'),
    DomainItem(name: 'DSA', icon: Icons.account_tree_rounded, desc: 'Arrays, Trees, Graphs, Lists'),
    DomainItem(name: 'System Design', icon: Icons.architecture_rounded, desc: 'Scalability, Load balancers'),
    DomainItem(name: 'Database', icon: Icons.storage_rounded, desc: 'SQL, NoSQL, Normalization'),
    DomainItem(name: 'OS', icon: Icons.computer_rounded, desc: 'Processes, Threads, Memory'),
    DomainItem(name: 'CN', icon: Icons.language_rounded, desc: 'TCP/IP, HTTP, OSI Model'),
    DomainItem(name: 'Aptitude', icon: Icons.psychology_rounded, desc: 'Logic, Math, Problem solving'),
    DomainItem(name: 'HR', icon: Icons.people_alt_rounded, desc: 'Behavioral questions & tips'),
    DomainItem(name: 'AI/ML', icon: Icons.smart_toy_rounded, desc: 'Models, Neural Nets, ML ops'),
  ];

  static IconData getDomainIcon(String domain) {
    for (final d in domains) {
      if (d.name.toLowerCase() == domain.toLowerCase()) {
        return d.icon;
      }
    }
    return Icons.book_rounded;
  }

  static Color getDomainColor(String domain, {bool isDark = false}) {
    switch (domain.toLowerCase()) {
      case 'flutter':
      case 'cn':
      case 'computer networks':
        return isDark ? AppTheme.lightBlueDark : AppTheme.lightBlueLight;
      case 'android':
      case 'ai/ml':
      case 'ai & machine learning':
        return isDark ? AppTheme.mintDark : AppTheme.mintLight;
      case 'java':
      case 'system design':
        return isDark ? AppTheme.lavenderDark : AppTheme.lavenderLight;
      default:
        return isDark ? AppTheme.peachDark : AppTheme.peachLight;
    }
  }

  static Color getDomainAccentColor(String domain) {
    switch (domain.toLowerCase()) {
      case 'flutter':
      case 'cn':
      case 'computer networks':
        return AppTheme.lightBlueDark;
      case 'android':
      case 'ai/ml':
      case 'ai & machine learning':
        return AppTheme.mintDark;
      case 'java':
      case 'system design':
        return AppTheme.lavenderDark;
      default:
        return AppTheme.peachDark;
    }
  }
}
