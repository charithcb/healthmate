import 'package:flutter_riverpod/flutter_riverpod.dart';

/// false = light mode (default)
/// true  = dark mode
final themeProvider = StateProvider<bool>((ref) => false);
