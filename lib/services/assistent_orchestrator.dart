import 'dart:convert';

import '../data/tables.dart';
import '../models/vorkommen.dart';
import 'assistent_funktionen.dart';
import 'ollama_service.dart';

/// Verbindet die Funktionsaufruf-Schnittstelle (`AssistentFunktionen`) mit
/// Ollamas Tool-Calling: definiert die Werkzeug-Schemas, führt angeforderte
/// Aufrufe aus und schleift das Ergebnis zurück in den Chat-Verlauf, bis
/// das Modell eine reine Textantwort liefert (Phase 8).
class AssistentOrchestrator {
  final OllamaService ollama;
  final AssistentFunktionen funktionen;

  AssistentOrchestrator({required this.ollama, required this.funktionen});

  static const _systemPrompt =
      'You are the offline assistant inside TRAUM Planer, a personal weekly '
      'planner app. Answer in the same language the user writes in (German '
      'or English). Use the provided tools to look up or change the '
      "user's tasks, plans, and events instead of guessing. Keep replies "
      'short and concrete.';

  static final List<Map<String, dynamic>> _tools = [
    _tool('heute_offen_abfragen', 'List today\'s tasks that are still open.', {}),
    _tool('heute_erledigt_abfragen', 'List today\'s tasks that are already done.', {}),
    _tool(
      'zeitraum_erledigt_abfragen',
      'List tasks completed within a date range.',
      {
        'von': _prop('string', 'Start date, ISO 8601 (YYYY-MM-DD).'),
        'bis': _prop('string', 'End date, ISO 8601 (YYYY-MM-DD).'),
      },
      required: ['von', 'bis'],
    ),
    _tool(
      'aufgabe_hinzufuegen',
      'Add a new recurring task to an existing plan.',
      {
        'planId': _prop('integer', 'ID of the plan this task belongs to.'),
        'titel': _prop('string', 'Task title.'),
        'uhrzeitMinuten': _prop('integer', 'Optional time of day, minutes since midnight.'),
        'wiederholung': _prop('string', 'One of: taeglich, wochentage, woechentlich, monatlich.'),
      },
      required: ['planId', 'titel', 'wiederholung'],
    ),
    _tool(
      'termin_hinzufuegen',
      'Add a new one-off calendar event.',
      {
        'titel': _prop('string', 'Event title.'),
        'datum': _prop('string', 'Date, ISO 8601 (YYYY-MM-DD).'),
        'uhrzeitMinuten': _prop('integer', 'Optional time of day, minutes since midnight.'),
      },
      required: ['titel', 'datum'],
    ),
    _tool(
      'aufgabe_rueckwirkend_abhaken',
      'Retroactively mark a task occurrence as done on a given date.',
      {
        'aufgabeId': _prop('integer', 'ID of the task.'),
        'datum': _prop('string', 'Due date of the occurrence, ISO 8601 (YYYY-MM-DD).'),
      },
      required: ['aufgabeId', 'datum'],
    ),
  ];

  static Map<String, dynamic> _prop(String typ, String beschreibung) =>
      {'type': typ, 'description': beschreibung};

  static Map<String, dynamic> _tool(
    String name,
    String beschreibung,
    Map<String, dynamic> properties, {
    List<String> required = const [],
  }) =>
      {
        'type': 'function',
        'function': {
          'name': name,
          'description': beschreibung,
          'parameters': {
            'type': 'object',
            'properties': properties,
            'required': required,
          },
        },
      };

  Future<String> nachrichtSenden(List<OllamaNachricht> verlauf) async {
    var arbeitsVerlauf = [
      OllamaNachricht(rolle: 'system', inhalt: _systemPrompt),
      ...verlauf,
    ];

    // Max. 4 Runden Tool-Calling, um eine Endlosschleife bei einem
    // widerspenstigen Modell auszuschließen.
    for (var runde = 0; runde < 4; runde++) {
      final antwort = await ollama.chatten(arbeitsVerlauf, tools: _tools);
      if (!antwort.hatToolCalls) return antwort.text;

      arbeitsVerlauf = [
        ...arbeitsVerlauf,
        OllamaNachricht(rolle: 'assistant', inhalt: antwort.text, toolCalls: antwort.toolCalls),
      ];

      for (final call in antwort.toolCalls) {
        final fn = call['function'] as Map<String, dynamic>;
        final name = fn['name'] as String;
        final argumenteRoh = fn['arguments'];
        final argumente = argumenteRoh is String
            ? jsonDecode(argumenteRoh) as Map<String, dynamic>
            : (argumenteRoh as Map<String, dynamic>? ?? const {});

        final ergebnis = await _aufrufen(name, argumente);
        arbeitsVerlauf.add(OllamaNachricht(rolle: 'tool', inhalt: jsonEncode(ergebnis), toolName: name));
      }
    }

    return await ollama.chatten(arbeitsVerlauf).then((a) => a.text);
  }

  Future<dynamic> _aufrufen(String name, Map<String, dynamic> args) async {
    try {
      switch (name) {
        case 'heute_offen_abfragen':
          return (await funktionen.heuteOffenAbfragen()).map(_vorkommenJson).toList();
        case 'heute_erledigt_abfragen':
          return (await funktionen.heuteErledigtAbfragen()).map(_vorkommenJson).toList();
        case 'zeitraum_erledigt_abfragen':
          final von = DateTime.parse(args['von'] as String);
          final bis = DateTime.parse(args['bis'] as String);
          return (await funktionen.zeitraumErledigtAbfragen(von, bis)).map(_vorkommenJson).toList();
        case 'aufgabe_hinzufuegen':
          final typ = _wiederholungsTypParsen(args['wiederholung'] as String);
          final a = await funktionen.aufgabeHinzufuegen(
            planId: args['planId'] as int,
            titel: args['titel'] as String,
            uhrzeitMinuten: args['uhrzeitMinuten'] as int?,
            typ: typ,
          );
          return {'id': a.id, 'titel': a.titel};
        case 'termin_hinzufuegen':
          final t = await funktionen.terminHinzufuegen(
            titel: args['titel'] as String,
            datum: DateTime.parse(args['datum'] as String),
            uhrzeitMinuten: args['uhrzeitMinuten'] as int?,
          );
          return {'id': t.id, 'titel': t.titel};
        case 'aufgabe_rueckwirkend_abhaken':
          await funktionen.aufgabeRueckwirkendAbhaken(
            aufgabeId: args['aufgabeId'] as int,
            datum: DateTime.parse(args['datum'] as String),
          );
          return {'ok': true};
        default:
          return {'error': 'unknown function: $name'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Map<String, dynamic> _vorkommenJson(Vorkommen v) => {
        'aufgabeId': v.aufgabe.id,
        'titel': v.titel,
        'plan': v.plan.titel,
        'datum': v.datum.toIso8601String().split('T').first,
        'uhrzeitMinuten': v.uhrzeitMinuten,
        'status': v.status.name,
      };

  WiederholungsTyp _wiederholungsTypParsen(String s) => switch (s) {
        'taeglich' => WiederholungsTyp.taeglich,
        'woechentlich' => WiederholungsTyp.woechentlich,
        'monatlich' => WiederholungsTyp.monatlich,
        _ => WiederholungsTyp.wochentage,
      };
}
