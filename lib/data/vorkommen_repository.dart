import 'package:rxdart/rxdart.dart';

import '../models/eintrag_status.dart';
import '../models/vorkommen.dart';
import 'database.dart';
import 'tables.dart';
import 'wiederholung_logik.dart';

/// Verbindet Pläne, Aufgaben, Wiederholungsregeln, Ausnahmen und
/// Erledigt-Einträge zu den fertigen [Vorkommen] eines Zeitraums.
/// Zentrale Stelle, die die "eine Zeile pro Vorkommen"-Regel aus der
/// Spezifikation umsetzt.
class VorkommenRepository {
  final AppDatabase db;

  VorkommenRepository(this.db);

  Stream<List<Vorkommen>> beobachteZeitraum(DateTime von, DateTime bis) {
    final vonDatum = nurDatum(von);
    final bisDatum = nurDatum(bis);
    return Rx.combineLatest5<List<Plan>, List<Aufgabe>, List<Wiederholungsregel>,
        List<ErledigtEintrag>, List<Ausnahme>, List<Vorkommen>>(
      db.alleplaeneBeobachten(),
      db.alleAufgabenBeobachten(),
      db.alleRegelnBeobachten(),
      db.erledigtImZeitraumBeobachten(vonDatum, bisDatum),
      db.ausnahmenImZeitraumBeobachten(vonDatum, bisDatum),
      (plaene, aufgaben, regeln, erledigtEintraege, ausnahmeEintraege) {
        final planNachId = {for (final p in plaene) p.id: p};
        final regelNachId = {for (final r in regeln) r.id: r};
        final erledigtNachSchluessel = {
          for (final e in erledigtEintraege) (e.aufgabeId, nurDatum(e.faelligDatum)): e,
        };
        final ausnahmeNachSchluessel = {
          for (final a in ausnahmeEintraege) (a.aufgabeId, nurDatum(a.datum)): a,
        };

        final ergebnis = <Vorkommen>[];
        for (var tag = vonDatum; !tag.isAfter(bisDatum); tag = tag.add(const Duration(days: 1))) {
          for (final aufgabe in aufgaben) {
            final regel = regelNachId[aufgabe.wiederholungsregelId];
            final plan = planNachId[aufgabe.planId];
            if (regel == null || plan == null) continue;
            if (!WiederholungLogik.istFaelligAm(regel, tag)) continue;

            final ausnahme = ausnahmeNachSchluessel[(aufgabe.id, tag)];
            if (ausnahme != null && ausnahme.typ == AusnahmeTyp.ausgefallen) continue;

            final erledigtEintrag = erledigtNachSchluessel[(aufgabe.id, tag)];
            final EintragStatus status;
            if (erledigtEintrag != null && erledigtEintrag.erledigt) {
              final erledigtTag = nurDatum(erledigtEintrag.erledigtAm ?? tag);
              status = erledigtTag.isAtSameMomentAs(tag)
                  ? EintragStatus.erledigtPuenktlich
                  : EintragStatus.erledigtVerspaetet;
            } else if (tag.isBefore(nurDatum(DateTime.now()))) {
              status = EintragStatus.verpasst;
            } else {
              status = EintragStatus.offen;
            }

            ergebnis.add(Vorkommen(
              aufgabe: aufgabe,
              plan: plan,
              datum: tag,
              titel: ausnahme?.neuerTitel ?? aufgabe.titel,
              uhrzeitMinuten: ausnahme?.neueUhrzeitMinuten ?? aufgabe.uhrzeitMinuten,
              status: status,
              erledigtAm: erledigtEintrag?.erledigtAm,
            ));
          }
        }
        return ergebnis;
      },
    );
  }

  Stream<List<TerminEintrag>> beobachteTermine(DateTime von, DateTime bis) {
    return db
        .termineImZeitraumBeobachten(nurDatum(von), nurDatum(bis))
        .map((liste) => liste.map(TerminEintrag.new).toList());
  }
}
