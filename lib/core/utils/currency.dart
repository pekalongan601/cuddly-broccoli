import '../../providers/app_state_provider.dart';

/// Format [amount] as Indonesian Rupiah (e.g. "Rp1.000.000").
String rupiah(num amount) {
  final int rounded = amount.round();
  final String absolute = rounded.abs().toString();
  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < absolute.length; i++) {
    final int remaining = absolute.length - i;
    buffer.write(absolute[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }

  return '${rounded.isNegative ? '-' : ''}Rp$buffer';
}

/// Strip non-digit characters from [input] and parse as a number.
num? parseRupiahInput(String input) {
  final String digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  return num.tryParse(digits);
}

/// Return either hidden placeholder or formatted amount.
String visibleMoney(AppState state, num amount) =>
    state.isBalanceHidden ? '••••••••' : rupiah(amount);
