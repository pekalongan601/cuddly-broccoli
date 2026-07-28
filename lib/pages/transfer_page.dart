import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';
import '../models/recipient.dart';
import '../services/mock_data.dart';
import '../widgets/common.dart';

/// Bayar/Transfer page.
class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  bool _favorite = false;
  String _query = '';

  List<Recipient> get _shownRecipients {
    final String query = _query.toLowerCase();
    return MockData.recipients
        .where((Recipient r) => !_favorite || r.name == 'Suparno' || r.name == 'Aris Prasetiawan')
        .where((Recipient r) => r.name.toLowerCase().contains(query) || r.detail.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: Container(color: Theme.of(context).scaffoldBackgroundColor)),
        const Positioned(top: 0, left: 0, right: 0, height: 280, child: ColoredBox(color: AppColors.orange)),
        SafeArea(
          bottom: false,
          child: CustomScrollView(
            key: const PageStorageKey('transfer-scroll'),
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(Layout.pagePaddingWide, 12, Layout.pagePaddingWide, 18),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    const Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Bayar/Transfer', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
                        ),
                        NotificationButton(dark: true),
                      ],
                    ),
                    const SizedBox(height: Layout.s20),
                    _transferOptions(),
                    const SizedBox(height: Layout.s16),
                    _recipientPanel(),
                    const SizedBox(height: Layout.s20),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _transferOptions() {
    const List<_TransferAction> actions = <_TransferAction>[
      _TransferAction('SeaBank', Icons.sailing_rounded),
      _TransferAction('Bank Lain', Icons.account_balance_rounded),
      _TransferAction('Virtual\nAccount', Icons.confirmation_number_rounded),
      _TransferAction('Top Up\nE-Wallet', Icons.account_balance_wallet_rounded, 'Baru'),
      _TransferAction('Top Up &\nTagihan', Icons.receipt_long_rounded),
      _TransferAction('Transfer\nGrup', Icons.group_add_rounded),
      _TransferAction('Transfer\nTerjadwal', Icons.event_available_rounded),
      _TransferAction('Tampilkan\nQR Bayar', Icons.qr_code_2_rounded),
    ];

    return SoftCard(
      radius: Layout.cardRadiusMd,
      padding: const EdgeInsets.fromLTRB(Layout.s14, Layout.s16, Layout.s14, Layout.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: Layout.s6),
            child: Text('Transfer ke', style: TextStyle(fontSize: Layout.fsSectionTitle, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: Layout.s14),
          GridView.builder(
            itemCount: actions.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisExtent: 100,
            ),
            itemBuilder: (_, int index) => _actionButton(actions[index]),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(_TransferAction action) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _showAction(action.label.replaceAll('\n', ' ')),
      child: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              OrangeCircleIcon(icon: action.icon, size: 42, iconSize: 22),
              if (action.badge != null)
                Positioned(
                  right: -18,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.badgeBg, borderRadius: BorderRadius.circular(5)),
                    child: Text(action.badge!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF633100))),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Layout.s6),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topCenter,
              child: Text(action.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, height: 1.1, color: Color(0xFF626262))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipientPanel() {
    return SoftCard(
      radius: Layout.cardRadiusXs,
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 56,
            child: Row(
              children: <Widget>[
                Expanded(child: _tab('Terakhir', !_favorite, () => setState(() => _favorite = false))),
                Expanded(child: _tab('Favorit', _favorite, () => setState(() => _favorite = true))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Layout.s16, Layout.s14, Layout.s16, 8),
            child: TextField(
              onChanged: (String value) => setState(() => _query = value),
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Cari penerima di sini',
                hintStyle: TextStyle(color: AppColors.hint, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, size: 22, color: Color(0xFF666666)),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                isDense: true,
              ),
            ),
          ),
          if (_shownRecipients.isEmpty)
            const Padding(padding: EdgeInsets.all(32), child: Text('Penerima tidak ditemukan', style: TextStyle(color: AppColors.muted)))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(Layout.s16, 6, Layout.s16, 8),
              itemCount: _shownRecipients.length,
              separatorBuilder: (_, __) => const Divider(height: 14),
              itemBuilder: (_, int index) => _recipientTile(_shownRecipients[index]),
            ),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: active ? AppColors.orange : AppColors.lineLight, width: active ? 3 : 1),
          ),
        ),
        child: Text(label, style: TextStyle(fontSize: 17, fontWeight: active ? FontWeight.w600 : FontWeight.w500, color: active ? AppColors.orange : AppColors.navShadow)),
      ),
    );
  }

  Widget _recipientTile(Recipient recipient) {
    return InkWell(
      onTap: () => _showRecipient(recipient),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: recipient.color, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(recipient.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: Layout.s14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(recipient.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 3),
                  Text(recipient.detail, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.star_border_rounded, color: AppColors.starYellow, size: 26),
          ],
        ),
      ),
    );
  }

  void _showAction(String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label dipilih')));
  }

  void _showRecipient(Recipient recipient) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(Layout.s20, Layout.s4, Layout.s20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Transfer ke ${recipient.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: Layout.s6),
              Text(recipient.detail, style: const TextStyle(color: AppColors.muted, fontSize: 14)),
              const SizedBox(height: Layout.s16),
              SizedBox(width: double.infinity, child: AppTextButton(label: 'Lanjutkan', onTap: () => Navigator.pop(context))),
            ],
          ),
        );
      },
    );
  }
}

class _TransferAction {
  const _TransferAction(this.label, this.icon, [this.badge]);
  final String label;
  final IconData icon;
  final String? badge;
}
