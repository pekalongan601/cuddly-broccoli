import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/currency.dart';
import '../providers/app_state_provider.dart';
import '../widgets/common.dart';

/// Developer-only settings page for local state manipulation.
class DeveloperSettingsPage extends ConsumerStatefulWidget {
  const DeveloperSettingsPage({super.key});

  @override
  ConsumerState<DeveloperSettingsPage> createState() =>
      _DeveloperSettingsPageState();
}

class _DeveloperSettingsPageState
    extends ConsumerState<DeveloperSettingsPage> {
  late final TextEditingController _totalBalanceCtrl;
  late final TextEditingController _savingsBalanceCtrl;
  final TextEditingController _adjustmentCtrl =
      TextEditingController();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _accountCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final AppState state = ref.read(appStateProvider);
    _totalBalanceCtrl = TextEditingController(
        text: state.balance.round().toString());
    _savingsBalanceCtrl = TextEditingController(
        text: state.savingsBalance.round().toString());
    _nameCtrl = TextEditingController(text: state.userName);
    _accountCtrl =
        TextEditingController(text: state.accountNumber);
    _phoneCtrl =
        TextEditingController(text: state.phoneNumber);
  }

  @override
  void dispose() {
    _totalBalanceCtrl.dispose();
    _savingsBalanceCtrl.dispose();
    _adjustmentCtrl.dispose();
    _nameCtrl.dispose();
    _accountCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = ref.watch(appStateProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text(
          'Developer Settings',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          padding:
              const EdgeInsets.fromLTRB(20, 15, 20, 32),
          children: <Widget>[
            const Text(
              'Local testing only',
              style: TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Perubahan disimpan secara lokal dan tetap tersedia '
              'setelah aplikasi dibuka kembali.',
              style:
                  TextStyle(color: AppColors.muted, height: 1.35),
            ),
            const SizedBox(height: 18),
            _group('Edit Total Balance', <Widget>[
              _currentValue(
                  'Saldo saat ini', state.balance, state.isBalanceHidden),
              const SizedBox(height: 12),
              _amountField(_totalBalanceCtrl, 'Total Balance',
                  hidden: state.isBalanceHidden),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Total Balance',
                  onTap: _saveTotalBalance,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Edit Savings Balance', <Widget>[
              _currentValue('Tabungan saat ini',
                  state.savingsBalance, state.isBalanceHidden),
              const SizedBox(height: 12),
              _amountField(_savingsBalanceCtrl, 'Savings Balance',
                  hidden: state.isBalanceHidden),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Savings Balance',
                  onTap: _saveSavingsBalance,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Tambah atau Kurangi Balance', <Widget>[
              const Text(
                'Nominal ini hanya mengubah Total Balance.',
                style:
                    TextStyle(color: AppColors.muted, height: 1.35),
              ),
              const SizedBox(height: 12),
              _amountField(_adjustmentCtrl, 'Nominal Penyesuaian'),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints constraints) {
                  final bool vertical = constraints.maxWidth < 290;
                  final Widget addButton = AppTextButton(
                    label: 'Tambah Balance',
                    onTap: _addBalance,
                  );
                  final Widget subtractButton = AppTextButton(
                    label: 'Kurangi Balance',
                    filled: false,
                    onTap: _subtractBalance,
                  );
                  if (vertical) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        addButton,
                        const SizedBox(height: 10),
                        subtractButton,
                      ],
                    );
                  }
                  return Row(
                    children: <Widget>[
                      Expanded(child: addButton),
                      const SizedBox(width: 12),
                      Expanded(child: subtractButton),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Reset Semua Balance',
                  filled: false,
                  onTap: _resetBalances,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Privasi Balance', <Widget>[
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.orange,
                activeTrackColor:
                    AppColors.orange.withOpacity(0.35),
                title: const Text(
                  'Sembunyikan Balance',
                  style:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                    'Tampilkan •••••••• pada seluruh balance.'),
                value: state.isBalanceHidden,
                onChanged:
                    ref.read(appStateProvider.notifier).setBalanceHidden,
              ),
            ]),
            const SizedBox(height: 16),
            _group('Edit User Name', <Widget>[
              TextField(
                controller: _nameCtrl,
                onChanged:
                    ref.read(appStateProvider.notifier).setUserName,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'User Name'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Nama',
                  onTap: () => _saveText(
                    _nameCtrl,
                    ref.read(appStateProvider.notifier).setUserName,
                    'Nama diperbarui',
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Edit Account Number', <Widget>[
              TextField(
                controller: _accountCtrl,
                onChanged:
                    ref.read(appStateProvider.notifier).setAccountNumber,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Account Number'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Nomor Rekening',
                  onTap: () => _saveText(
                    _accountCtrl,
                    ref.read(appStateProvider.notifier).setAccountNumber,
                    'Nomor rekening diperbarui',
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Edit Phone Number', <Widget>[
              TextField(
                controller: _phoneCtrl,
                onChanged:
                    ref.read(appStateProvider.notifier).setPhoneNumber,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Nomor Telepon',
                  onTap: () => _saveText(
                    _phoneCtrl,
                    ref.read(appStateProvider.notifier).setPhoneNumber,
                    'Nomor telepon diperbarui',
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Theme', <Widget>[
              const Text(
                'Pilih tema untuk aplikasi demo lokal ini.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  segments: const <ButtonSegment<ThemeMode>>[
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                  ],
                  selected: <ThemeMode>{state.themeMode},
                  onSelectionChanged: (Set<ThemeMode> values) =>
                      ref
                          .read(appStateProvider.notifier)
                          .setThemeMode(values.first),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Shared widgets
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _currentValue(String label, num value, bool hidden) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              hidden ? '••••••••' : rupiah(value),
              style: const TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _amountField(
    TextEditingController controller,
    String label, {
    bool hidden = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: hidden,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration:
          InputDecoration(labelText: label, prefixText: 'Rp'),
    );
  }

  Widget _group(String title, List<Widget> children) {
    return SoftCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Actions
  // ═══════════════════════════════════════════════════════════════════════════

  void _saveTotalBalance() {
    final num? value = parseRupiahInput(_totalBalanceCtrl.text);
    if (value == null) return _invalidAmount();
    ref.read(appStateProvider.notifier).setBalance(value);
    _totalBalanceCtrl.text = value.round().toString();
    _confirm('Total Balance diperbarui menjadi ${rupiah(value)}');
  }

  void _saveSavingsBalance() {
    final num? value =
        parseRupiahInput(_savingsBalanceCtrl.text);
    if (value == null) return _invalidAmount();
    ref.read(appStateProvider.notifier).setSavingsBalance(value);
    _savingsBalanceCtrl.text = value.round().toString();
    _confirm(
        'Savings Balance diperbarui menjadi ${rupiah(value)}');
  }

  void _addBalance() {
    final num? value =
        parseRupiahInput(_adjustmentCtrl.text);
    if (value == null || value <= 0) return _invalidAmount();
    ref.read(appStateProvider.notifier).addBalance(value);
    _adjustmentCtrl.clear();
    _totalBalanceCtrl.text =
        ref.read(appStateProvider).balance.round().toString();
    _confirm('Balance bertambah ${rupiah(value)}');
  }

  void _subtractBalance() {
    final num? value =
        parseRupiahInput(_adjustmentCtrl.text);
    if (value == null || value <= 0) return _invalidAmount();
    final bool didSubtract =
        ref.read(appStateProvider.notifier).subtractBalance(value);
    if (!didSubtract) {
      _confirm('Balance tidak boleh menjadi negatif');
      return;
    }
    _adjustmentCtrl.clear();
    _totalBalanceCtrl.text =
        ref.read(appStateProvider).balance.round().toString();
    _confirm('Balance berkurang ${rupiah(value)}');
  }

  void _resetBalances() {
    ref.read(appStateProvider.notifier).resetBalance();
    final AppState state = ref.read(appStateProvider);
    _totalBalanceCtrl.text = state.balance.round().toString();
    _savingsBalanceCtrl.text =
        state.savingsBalance.round().toString();
    _adjustmentCtrl.clear();
    _confirm('Semua balance dikembalikan ke nilai awal');
  }

  void _saveText(
    TextEditingController controller,
    void Function(String) update,
    String confirmation,
  ) {
    update(controller.text);
    _confirm(confirmation);
  }

  void _invalidAmount() =>
      _confirm('Masukkan nominal Rupiah yang valid');

  void _confirm(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
}
