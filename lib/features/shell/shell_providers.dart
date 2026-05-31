import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Currently selected bottom-nav tab index for [MainShell].
final shellTabProvider = StateProvider<int>((ref) => 0);
