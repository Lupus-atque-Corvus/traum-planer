import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/assistent_funktionen.dart';
import '../services/assistent_orchestrator.dart';
import '../services/ollama_service.dart';
import '../services/stt_service.dart';
import '../services/tts_service.dart';
import 'database_provider.dart';

class ChatNachricht {
  final String rolle; // 'user' | 'assistant'
  final String text;
  const ChatNachricht({required this.rolle, required this.text});
}

final ollamaServiceProvider = Provider((ref) => const OllamaService());

final ollamaErreichbarProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(ollamaServiceProvider).istErreichbar();
});

final assistentOrchestratorProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(vorkommenRepositoryProvider);
  return AssistentOrchestrator(
    ollama: ref.watch(ollamaServiceProvider),
    funktionen: AssistentFunktionen(db, repo),
  );
});

final sttServiceProvider = Provider<SttService>((ref) {
  final service = SttService();
  ref.onDispose(service.dispose);
  return service;
});

final ttsServiceProvider = Provider((ref) => const TtsService());

final ttsAktivProvider = StateProvider<bool>((ref) => false);

class AssistentChatController extends StateNotifier<List<ChatNachricht>> {
  final AssistentOrchestrator orchestrator;
  AssistentChatController(this.orchestrator) : super([]);

  bool sendetGerade = false;

  Future<void> senden(String text) async {
    if (text.trim().isEmpty || sendetGerade) return;
    sendetGerade = true;
    state = [...state, ChatNachricht(rolle: 'user', text: text)];

    try {
      final verlauf = state
          .map((n) => OllamaNachricht(rolle: n.rolle == 'user' ? 'user' : 'assistant', inhalt: n.text))
          .toList();
      final antwort = await orchestrator.nachrichtSenden(verlauf);
      state = [...state, ChatNachricht(rolle: 'assistant', text: antwort)];
    } catch (e) {
      state = [...state, ChatNachricht(rolle: 'assistant', text: '⚠ $e')];
    } finally {
      sendetGerade = false;
    }
  }
}

final assistentChatProvider =
    StateNotifierProvider.autoDispose<AssistentChatController, List<ChatNachricht>>((ref) {
  return AssistentChatController(ref.watch(assistentOrchestratorProvider));
});
