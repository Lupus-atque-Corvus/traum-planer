import 'dart:convert';

import 'package:http/http.dart' as http;

/// Eine einzelne Chat-Nachricht im Ollama-Format.
class OllamaNachricht {
  final String rolle; // 'system' | 'user' | 'assistant' | 'tool'
  final String inhalt;
  final List<Map<String, dynamic>>? toolCalls;
  final String? toolName;

  const OllamaNachricht({
    required this.rolle,
    required this.inhalt,
    this.toolCalls,
    this.toolName,
  });

  Map<String, dynamic> toJson() => {
        'role': rolle,
        'content': inhalt,
        if (toolCalls != null) 'tool_calls': toolCalls,
        if (toolName != null) 'name': toolName,
      };
}

/// Ergebnis eines Chat-Aufrufs: entweder eine Textantwort oder ein oder
/// mehrere angeforderte Funktionsaufrufe (Tool-Calls).
class OllamaAntwort {
  final String text;
  final List<Map<String, dynamic>> toolCalls;

  const OllamaAntwort({required this.text, required this.toolCalls});

  bool get hatToolCalls => toolCalls.isNotEmpty;
}

/// Client für die lokale Ollama-API (`http://localhost:11434`), Phase 8.
/// Läuft ausschließlich gegen den lokalen Server — keine Cloud, kein
/// externer Netzwerkzugriff. Ollama selbst muss lokal installiert und
/// gestartet sein (siehe README).
class OllamaService {
  final String basisUrl;
  final String modell;

  const OllamaService({this.basisUrl = 'http://localhost:11434', this.modell = 'qwen2.5:3b'});

  Future<bool> istErreichbar() async {
    try {
      final res = await http.get(Uri.parse('$basisUrl/api/version')).timeout(const Duration(seconds: 2));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<OllamaAntwort> chatten(
    List<OllamaNachricht> verlauf, {
    List<Map<String, dynamic>>? tools,
  }) async {
    final res = await http.post(
      Uri.parse('$basisUrl/api/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': modell,
        'stream': false,
        'messages': verlauf.map((n) => n.toJson()).toList(),
        'tools': ?tools,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Ollama-Fehler ${res.statusCode}: ${res.body}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final message = json['message'] as Map<String, dynamic>;
    final toolCalls = (message['tool_calls'] as List?)?.cast<Map<String, dynamic>>() ?? const [];

    return OllamaAntwort(text: (message['content'] as String?) ?? '', toolCalls: toolCalls);
  }
}
