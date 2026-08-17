import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:traum_planer/main.dart';

void main() {
  testWidgets('App startet und zeigt die Heute-Ansicht', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TraumPlanerApp()));
    await tester.pump();

    expect(find.text('TRAUM Planer'), findsWidgets);
  });
}
