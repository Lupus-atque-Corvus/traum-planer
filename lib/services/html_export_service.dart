import 'package:intl/intl.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/vorkommen.dart';
import '../providers/kalender_provider.dart';
import '../utils/zeit_format.dart';

/// Erzeugt ein druckbares HTML-Wochenblatt (A3 quer), zweisprachig je nach
/// aktueller App-Sprache (Phase 6 + 7). Reines String-Templating, keine
/// externen Abhängigkeiten — funktioniert vollständig offline.
class HtmlExportService {
  const HtmlExportService._();

  static String wochenblatt({
    required DateTime anker,
    required List<Vorkommen> vorkommen,
    required List<TerminEintrag> termine,
    required AppLocalizations l10n,
    required String locale,
    required bool ist24h,
  }) {
    final tage = wochenTage(anker);
    final proTag = <DateTime, List<_ZeileHtml>>{for (final t in tage) t: []};

    for (final v in vorkommen) {
      proTag[v.datum]?.add(_ZeileHtml(
        titel: v.titel,
        uhrzeit: v.uhrzeitMinuten != null ? formatiereUhrzeit(v.uhrzeitMinuten!, ist24h: ist24h) : null,
        kategorie: v.plan.kategorie,
        farbe: '#${v.plan.akzentfarbe.toRadixString(16).substring(2)}',
        erledigt: v.istErledigt,
      ));
    }
    for (final t in termine) {
      proTag[t.datum]?.add(_ZeileHtml(
        titel: t.titel,
        uhrzeit: t.uhrzeitMinuten != null ? formatiereUhrzeit(t.uhrzeitMinuten!, ist24h: ist24h) : null,
        kategorie: l10n.terminLabel,
        farbe: '#3A4050',
        erledigt: false,
      ));
    }

    final spanne =
        '${DateFormat.yMMMd(locale).format(tage.first)} – ${DateFormat.yMMMd(locale).format(tage.last)}';
    final erstelltAm = l10n.exportDruckErstelltAm(DateFormat.yMMMd(locale).add_Hm().format(DateTime.now()));

    final spalten = tage.map((tag) {
      final zeilen = proTag[tag] ?? const [];
      final tagesName = _grossAnfangsbuchstabe(DateFormat.EEEE(locale).format(tag));
      final zeilenHtml = zeilen.isEmpty
          ? '<div class="leer"></div>'
          : zeilen.map((z) => z.toHtml()).join();
      return '''
        <section class="spalte">
          <header>
            <div class="wochentag">$tagesName</div>
            <div class="tagesnummer">${tag.day}.${tag.month}.</div>
          </header>
          $zeilenHtml
        </section>''';
    }).join();

    return '''
<!doctype html>
<html lang="$locale">
<head>
<meta charset="utf-8">
<title>${_escape(l10n.exportDruckTitel)}</title>
<style>
  @page { size: A3 landscape; margin: 14mm; }
  * { box-sizing: border-box; }
  body {
    font-family: "Segoe UI", Arial, sans-serif;
    color: #14161C;
    margin: 0;
  }
  .kopf { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 8mm; }
  h1 { font-size: 22pt; margin: 0; }
  .spanne { font-size: 12pt; color: #444; }
  .meta { font-size: 9pt; color: #888; }
  .raster { display: grid; grid-template-columns: repeat(7, 1fr); gap: 4mm; }
  .spalte { border: 1px solid #ccc; border-radius: 3mm; padding: 3mm; min-height: 140mm; }
  .spalte header { border-bottom: 1px solid #ddd; padding-bottom: 2mm; margin-bottom: 2mm; }
  .wochentag { font-weight: 600; font-size: 11pt; }
  .tagesnummer { font-size: 9pt; color: #888; }
  .zeile { border-left: 3px solid; padding: 1.5mm 2mm; margin-bottom: 1.5mm; background: #f7f7f8; border-radius: 1mm; font-size: 9pt; }
  .zeile.erledigt { opacity: 0.5; text-decoration: line-through; }
  .zeile .titel { font-weight: 500; }
  .zeile .info { color: #777; font-size: 8pt; }
  .leer { font-size: 8pt; color: #bbb; padding: 2mm 0; }
  @media print {
    .spalte { break-inside: avoid; }
  }
</style>
</head>
<body>
  <div class="kopf">
    <div>
      <h1>${_escape(l10n.exportDruckTitel)}</h1>
      <div class="spanne">$spanne</div>
    </div>
    <div class="meta">${_escape(erstelltAm)}</div>
  </div>
  <div class="raster">
    $spalten
  </div>
</body>
</html>
''';
  }

  static String _grossAnfangsbuchstabe(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static String _escape(String s) =>
      s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
}

class _ZeileHtml {
  final String titel;
  final String? uhrzeit;
  final String kategorie;
  final String farbe;
  final bool erledigt;

  const _ZeileHtml({
    required this.titel,
    required this.uhrzeit,
    required this.kategorie,
    required this.farbe,
    required this.erledigt,
  });

  String toHtml() {
    final info = [if (uhrzeit != null) uhrzeit, kategorie].join(' · ');
    return '''
      <div class="zeile${erledigt ? ' erledigt' : ''}" style="border-left-color: $farbe;">
        <div class="titel">${HtmlExportService._escape(titel)}</div>
        <div class="info">${HtmlExportService._escape(info)}</div>
      </div>''';
  }
}
