import 'package:mind_boost/models/learning_card.dart';
import 'package:mind_boost/services/openai_service.dart';
import 'package:mind_boost/services/storage_service.dart';

class CardRepository {
  Future<LearningCard> getCardForTopic(String topic) async {
    try {
      // Try to generate a new card from OpenAI
      final card = await OpenAiService.generateCard(topic);

      // Save/cache to Hive
      await StorageService.saveCard(card);

      return card;
    } catch (e) {
      // If generation fails (offline / api error), check local cache
      final cachedCards = StorageService.getSavedCards();
      final topicCards = cachedCards
          .where((c) => c.topic.toLowerCase() == topic.toLowerCase())
          .toList();

      if (topicCards.isNotEmpty) {
        // Return the latest cached card for this topic
        topicCards.sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
        return topicCards.first;
      }

      // If no cache, rethrow with helpful message
      throw Exception(
        'Failed to connect to AI server and no offline cache found for "$topic". Check your connection and try again.',
      );
    }
  }

  List<LearningCard> getCachedCards() {
    return StorageService.getSavedCards();
  }

  Future<void> deleteCard(String id) async {
    await StorageService.deleteCard(id);
  }

  Future<void> clearAll() async {
    await StorageService.clearCards();
  }
}
