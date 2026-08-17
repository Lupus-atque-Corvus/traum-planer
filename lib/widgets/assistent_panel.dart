import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/gen/app_localizations.dart';
import '../providers/assistent_chat_provider.dart';
import '../providers/assistent_provider.dart';
import '../providers/einstellungen_provider.dart';
import '../theme/tokens.dart';

/// Bildschirm 10 der Spec: schwebendes Panel (360×480), Kopfzeile
/// "Assistent", Nachrichtenverlauf, Eingabezeile mit Mikrofon-/Senden-
/// Button. Phase 8: echtes lokales STT (whisper.cpp) + LLM (Ollama) +
/// optionales TTS, alles offline. Fällt sauber auf einen Hinweistext
/// zurück, wenn Ollama nicht läuft — die App bleibt ohne LLM voll
/// nutzbar (Spec-Vorgabe).
class AssistentPanel extends ConsumerStatefulWidget {
  const AssistentPanel({super.key});

  @override
  ConsumerState<AssistentPanel> createState() => _AssistentPanelState();
}

class _AssistentPanelState extends ConsumerState<AssistentPanel> {
  final _eingabeController = TextEditingController();
  final _scrollController = ScrollController();
  bool _nimmtAuf = false;
  bool _transkribiert = false;

  @override
  void dispose() {
    _eingabeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollAnsEnde() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _senden() async {
    final text = _eingabeController.text;
    if (text.trim().isEmpty) return;
    _eingabeController.clear();
    await ref.read(assistentChatProvider.notifier).senden(text);
    _scrollAnsEnde();

    if (ref.read(ttsAktivProvider) && mounted) {
      final nachrichten = ref.read(assistentChatProvider);
      if (nachrichten.isNotEmpty && nachrichten.last.rolle == 'assistant') {
        final sprache = ref.read(spracheProvider).valueOrNull ?? 'de';
        await ref
            .read(ttsServiceProvider)
            .sprechen(nachrichten.last.text, sprache: sprache == 'en' ? 'en' : 'de');
      }
    }
  }

  Future<void> _mikrofonUmschalten() async {
    final stt = ref.read(sttServiceProvider);
    if (_nimmtAuf) {
      setState(() {
        _nimmtAuf = false;
        _transkribiert = true;
      });
      final text = await stt.aufnahmeStoppenUndErkennen();
      if (!mounted) return;
      setState(() => _transkribiert = false);
      if (text.isNotEmpty) {
        _eingabeController.text = text;
        _eingabeController.selection = TextSelection.collapsed(offset: text.length);
      }
      return;
    }

    final berechtigt = await stt.mikrofonBerechtigungVorhanden();
    if (!berechtigt) return;
    await stt.aufnahmeStarten();
    if (!mounted) return;
    setState(() => _nimmtAuf = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ollamaAsync = ref.watch(ollamaErreichbarProvider);
    final ollamaErreichbar = ollamaAsync.valueOrNull ?? false;
    final nachrichten = ref.watch(assistentChatProvider);
    final sendetGerade = ref.watch(assistentChatProvider.notifier).sendetGerade;
    final ttsAktiv = ref.watch(ttsAktivProvider);

    return Container(
      width: 360,
      height: 480,
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.dialog),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 24, offset: Offset(0, 8))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Text(l10n.assistentTitel, style: Theme.of(context).textTheme.titleMedium),
                ),
                IconButton(
                  icon: Icon(ttsAktiv ? Icons.volume_up_outlined : Icons.volume_off_outlined, size: 18),
                  tooltip: ttsAktiv ? l10n.assistentTtsEin : l10n.assistentTtsAus,
                  onPressed: () => ref.read(ttsAktivProvider.notifier).state = !ttsAktiv,
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: l10n.assistentSchliessen,
                  onPressed: () => ref.read(assistentPanelSichtbarProvider.notifier).state = false,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),
          Expanded(
            child: !ollamaErreichbar
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Text(
                        l10n.assistentOllamaNichtErreichbar,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: AppColors.textTertiary, height: 1.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: nachrichten.length,
                    itemBuilder: (context, i) => _Nachrichtenblase(nachricht: nachrichten[i]),
                  ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _eingabeController,
                    enabled: ollamaErreichbar && !sendetGerade,
                    onSubmitted: (_) => _senden(),
                    decoration: InputDecoration(
                      hintText: _nimmtAuf
                          ? '…'
                          : _transkribiert
                              ? '…'
                              : l10n.assistentEingabePlatzhalter,
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                IconButton(
                  icon: Icon(_nimmtAuf ? Icons.stop_circle_outlined : Icons.mic_none_outlined, size: 18),
                  color: _nimmtAuf ? AppColors.destructive : null,
                  tooltip: l10n.assistentMikrofonHinweis,
                  onPressed: ollamaErreichbar && !sendetGerade && !_transkribiert ? _mikrofonUmschalten : null,
                ),
                IconButton(
                  icon: sendetGerade
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_outlined, size: 18),
                  onPressed: ollamaErreichbar && !sendetGerade ? _senden : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Nachrichtenblase extends StatelessWidget {
  final ChatNachricht nachricht;
  const _Nachrichtenblase({required this.nachricht});

  @override
  Widget build(BuildContext context) {
    final istNutzer = nachricht.rolle == 'user';
    return Align(
      alignment: istNutzer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: istNutzer ? AppColors.brandPrimary : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Text(
          nachricht.text,
          style: TextStyle(
            fontSize: 13,
            color: istNutzer ? AppColors.textPrimary : AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
