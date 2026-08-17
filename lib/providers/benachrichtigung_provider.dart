import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/benachrichtigung_service.dart';

final benachrichtigungServiceProvider = Provider<BenachrichtigungService>((ref) {
  final service = BenachrichtigungService();
  service.init();
  ref.onDispose(service.dispose);
  return service;
});
