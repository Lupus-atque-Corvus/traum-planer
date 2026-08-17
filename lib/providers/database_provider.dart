import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/vorkommen_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final vorkommenRepositoryProvider = Provider<VorkommenRepository>((ref) {
  return VorkommenRepository(ref.watch(databaseProvider));
});

final allePlaeneProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(databaseProvider).alleplaeneBeobachten();
});
