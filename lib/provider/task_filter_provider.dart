
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskFilterProvider = StateProvider<Map<String, dynamic>>((ref) => {
  'priority': null,
  'completed': null,
});
