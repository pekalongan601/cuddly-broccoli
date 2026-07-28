import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the selected bottom navigation tab index.
final selectedTabProvider = StateProvider<int>((_) => 0);

/// Whether the profile section is expanded.
final profileExpandedProvider = StateProvider<bool>((_) => false);
