import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mind_boost/models/note.dart';
import 'package:mind_boost/providers/providers.dart';
import 'package:mind_boost/theme/app_theme.dart';
import 'package:mind_boost/utils/app_constants.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterTab = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditNoteDialog([Note? note]) {
    final isEdit = note != null;
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    final selectedTopics = ref.read(selectedTopicsNotifierProvider);
    String selectedTopic = note?.topic ?? (selectedTopics.isNotEmpty ? selectedTopics.first : 'Flutter');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isEdit ? 'Edit Note' : 'Create Note',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedTopic,
                      decoration: const InputDecoration(labelText: 'Topic'),
                      items: (selectedTopics.isNotEmpty ? selectedTopics : ['Flutter', 'Python', 'Java', 'DSA'])
                          .map((topic) => DropdownMenuItem(value: topic, child: Text(topic)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedTopic = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title', hintText: 'e.g., Riverpod vs Provider'),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: contentController,
                      decoration: const InputDecoration(labelText: 'Content', hintText: 'Write key takeaways here...', alignLabelWithHint: true),
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = titleController.text.trim();
                          final content = contentController.text.trim();
                          if (title.isEmpty || content.isEmpty) return;
                          if (isEdit) {
                            ref.read(notesNotifierProvider.notifier).updateNote(
                              note.copyWith(title: title, content: content, topic: selectedTopic),
                            );
                          } else {
                            ref.read(notesNotifierProvider.notifier).addNote(title, content, selectedTopic);
                          }
                          Navigator.pop(context);
                        },
                        child: Text(isEdit ? 'Save Changes' : 'Create Note'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTopics = ref.watch(selectedTopicsNotifierProvider);

    // Build filter tabs: All, Pinned, then each selected topic
    final tabs = ['All', 'Pinned', ...selectedTopics];

    // Filter notes
    List<Note> filteredNotes = notes.where((note) {
      final matchesSearch = _searchQuery.isEmpty ||
          note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.topic.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesTab = true;
      if (_filterTab == 'Pinned') {
        matchesTab = note.isPinned;
      } else if (_filterTab != 'All') {
        matchesTab = note.topic.toLowerCase() == _filterTab.toLowerCase();
      }

      return matchesSearch && matchesTab;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditNoteDialog(),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.grayText),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter tabs
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isSelected = _filterTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tab),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryPurple,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12,
                      color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : AppTheme.darkCharcoal),
                    ),
                    onSelected: (_) => setState(() => _filterTab = tab),
                    visualDensity: VisualDensity.compact,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Notes grid
          Expanded(
            child: filteredNotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkSurface : AppTheme.primaryPurpleLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.note_alt_outlined, size: 48, color: AppTheme.primaryPurple),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No notes yet!' : 'No results found',
                          style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700,
                            color: isDark ? AppTheme.whiteText : AppTheme.darkCharcoal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Tap "+" to start jotting down study points.'
                              : 'Try different keywords.',
                          style: const TextStyle(color: AppTheme.grayText, fontSize: 13),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      final accentColor = AppConstants.getDomainAccentColor(note.topic);

                      return GestureDetector(
                        onTap: () => _showAddEditNoteDialog(note),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: note.isPinned
                                  ? AppTheme.primaryPurple
                                  : (isDark ? const Color(0xFF2D3748) : Colors.grey.shade200),
                              width: note.isPinned ? 2 : 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Topic tag + pin
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isDark ? accentColor.withAlpha(30) : AppConstants.getDomainColor(note.topic),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        note.topic,
                                        maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: accentColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => ref.read(notesNotifierProvider.notifier).togglePin(note.id),
                                    child: Icon(
                                      note.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                                      size: 16,
                                      color: note.isPinned ? AppTheme.primaryPurple : AppTheme.grayText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                note.title,
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700,
                                  color: isDark ? AppTheme.whiteText : AppTheme.darkCharcoal,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Text(
                                  note.content,
                                  maxLines: 3, overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12, color: isDark ? Colors.grey[400] : AppTheme.grayText, height: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Delete Note'),
                                          content: const Text('Are you sure?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                            TextButton(
                                              onPressed: () {
                                                ref.read(notesNotifierProvider.notifier).deleteNote(note.id);
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().scale(delay: (index * 30).ms, duration: 250.ms, begin: const Offset(0.92, 0.92));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
