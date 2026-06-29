import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mind_boost/models/learning_card.dart';
import 'package:mind_boost/services/storage_service.dart';

class OpenAiService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<LearningCard> generateCard(String topic) async {
    final apiKey = StorageService.getOpenAiApiKey().trim();

    if (apiKey.isEmpty) {
      // If no API key, return mock data for testing/demo purposes
      await Future.delayed(const Duration(seconds: 1)); // Simulate network lag
      return _generateMockCard(topic, isDemo: true);
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'response_format': {'type': 'json_object'},
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an expert technical interviewer. Generate a concise, high-quality interview preparation card about the requested topic. '
                  'The output MUST be a valid JSON object matching this structure EXACTLY: '
                  '{\n'
                  '  "title": "Name of the sub-topic or core concept",\n'
                  '  "explanation": "A simple explanation of the concept under 60 words.",\n'
                  '  "bulletPoints": ["Point 1", "Point 2", "Point 3", "Point 4"],\n'
                  '  "interviewQuestion": "A realistic and common interview question on this topic.",\n'
                  '  "sampleAnswer": "A high-scoring model answer for that question under 80 words.",\n'
                  '  "quickTip": "A neat trick, gotcha, or optimization advice related to this topic.",\n'
                  '  "readingTime": "2-3 min"\n'
                  '}\n'
                  'Ensure bulletPoints contains between 3 and 5 items. Do not include markdown formatting like ```json or ``` surrounding the JSON. Output pure raw JSON.',
            },
            {
              'role': 'user',
              'content': 'Generate an interview card about: $topic',
            },
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        final content = body['choices'][0]['message']['content'] as String;
        final Map<String, dynamic> cardJson =
            jsonDecode(content.trim()) as Map<String, dynamic>;

        return LearningCard.fromJson({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'topic': topic,
          ...cardJson,
          'generatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        final error = jsonDecode(response.body);
        final errorMessage =
            error['error']?['message'] ?? 'Unknown OpenAI Error';
        throw Exception(
          'OpenAI API Error (${response.statusCode}): $errorMessage',
        );
      }
    } catch (e) {
      // Fallback to offline/mock cards on error if needed, or throw
      rethrow;
    }
  }

  static LearningCard _generateMockCard(String topic, {bool isDemo = false}) {
    final prefix = isDemo ? '[DEMO] ' : '';
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    switch (topic.toLowerCase()) {
      case 'flutter':
        return LearningCard(
          id: id,
          title: '${prefix}Flutter Widget Lifecycle',
          topic: topic,
          explanation:
              'Widgets in Flutter represent the user interface. StatefulWidgets have a Lifecycle managed by a State object which tracks creation, updating, and disposal.',
          bulletPoints: [
            'createState(): Called when Flutter builds a StatefulWidget to establish its mutable state.',
            'initState(): Triggered exactly once when the widget enters the tree. Used to initialize variables or subscribe to streams.',
            'didChangeDependencies(): Invoked when inherited widgets (like Theme or MediaQuery) change.',
            'build(): Called repeatedly to render UI. Must be pure and side-effect free.',
            'dispose(): Invoked when the widget is permanently removed. Clean up controllers, listeners, etc.',
          ],
          interviewQuestion:
              'What is the purpose of initState() and dispose() in Flutter?',
          sampleAnswer:
              'initState() is called once when the stateful widget is inserted into the widget tree. It is used to initialize controllers, listeners, or fetch initial state. dispose() is called when the widget is removed permanently, letting you clean up resources to prevent memory leaks.',
          quickTip:
              'Never call setState() inside initState() directly. Use Future.delayed or addPostFrameCallback if you need to trigger callbacks after the build.',
          readingTime: '2 min',
          generatedAt: now,
        );

      case 'data structures':
      case 'algorithms':
        return LearningCard(
          id: id,
          title: '${prefix}Binary Search Trees (BST)',
          topic: topic,
          explanation:
              'A BST is a node-based binary tree data structure where each node has at most two children. The left subtree contains keys smaller than the node, and the right subtree contains keys larger.',
          bulletPoints: [
            'Search, Insert, and Delete operations take O(log n) time complexity on average.',
            'Skewed BSTs (like a linked list) degrade performance to O(n) time complexity.',
            'In-order traversal of a BST visits nodes in ascending sorted order.',
            'Balanced trees like AVL or Red-Black trees prevent performance degradation.',
          ],
          interviewQuestion:
              'What is the worst-case time complexity of BST operations, and how do you fix it?',
          sampleAnswer:
              'The worst-case time complexity is O(n) when the tree becomes unbalanced (skewed into a straight line). This can be resolved by using Self-Balancing Binary Search Trees, such as AVL trees or Red-Black trees, which guarantee O(log n) operations by performing rotations during insertions and deletions.',
          quickTip:
              'Remember that In-Order Traversal is the easiest way to verify if a tree structure is a valid Binary Search Tree.',
          readingTime: '3 min',
          generatedAt: now,
        );

      case 'oop':
        return LearningCard(
          id: id,
          title: '${prefix}The Four Pillars of OOP',
          topic: topic,
          explanation:
              'Object-Oriented Programming centers on organizing code into reusable objects. It relies on four primary concepts to achieve maintainable software architecture.',
          bulletPoints: [
            'Encapsulation: Hiding internal object state and exposing operations through methods.',
            'Abstraction: Hiding complex implementation details and showing only essential features.',
            'Inheritance: Deriving new classes from existing ones to promote code reuse.',
            'Polymorphism: Allowing different objects to respond to the same message in unique ways.',
          ],
          interviewQuestion:
              'What is the difference between Method Overloading and Method Overriding?',
          sampleAnswer:
              'Method Overloading occurs when multiple methods in the same class have the same name but different signatures (compile-time polymorphism). Method Overriding occurs when a subclass redefines a method inherited from a parent class with the exact same signature (runtime polymorphism).',
          quickTip:
              'Favor composition over inheritance to create highly flexible and decoupled class designs.',
          readingTime: '2 min',
          generatedAt: now,
        );

      default:
        return LearningCard(
          id: id,
          title: '$prefix$topic Core Concepts',
          topic: topic,
          explanation:
              'An overview of essential concepts for preparing interviews on $topic, focusing on fundamental architectures and high-impact terminology.',
          bulletPoints: [
            'Understand foundational syntax and memory layout configurations.',
            'Learn common library design patterns and state propagation schemes.',
            'Master optimal performance strategies and testing architectures.',
            'Be prepared to answer debugging, security, and integration questions.',
          ],
          interviewQuestion:
              'What are the main architectural layers to consider in $topic?',
          sampleAnswer:
              'A typical setup includes a presentation layer for user interfaces, a domain layer for business logic and entities, and a data layer for external APIs or local databases. Keeping these decoupled ensures testability.',
          quickTip:
              'Always explain your thought process out loud to interviewers, starting from simple solutions before optimizing.',
          readingTime: '3 min',
          generatedAt: now,
        );
    }
  }
}
