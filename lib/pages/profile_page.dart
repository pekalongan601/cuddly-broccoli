import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';
import '../providers/app_state_provider.dart';
import '../widgets/common.dart';

/// Profile / "Saya" screen.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState state = ref.watch(appStateProvider);

    return Stack(
      children: <Widget>[
        const Positioned(top: 0, left: 0, right: 0, height: 180, child: ColoredBox(color: AppColors.orange)),
        SafeArea(
          bottom: false,
          child: CustomScrollView(
            key: const PageStorageKey('profile-scroll'),
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(Layout.pagePadding, 10, Layout.pagePadding, 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    _profileHeader(state),
                    const SizedBox(height: Layout.s28),
                    _notice(Icons.fingerprint_rounded, 'Log in dengan sidik jari', 'Aktifkan verifikasi sidik jari untuk log in lebih\ncepat dan aman tanpa password!', 'Aktifkan Sekarang'),
                    const SizedBox(height: Layout.s12),
                    _notice(Icons.mark_email_read_outlined, 'Verifikasi Email Kamu Sekarang', 'Dapatkan info transaksi & promo, serta\npulihkan password dengan mudah!', 'Verifikasi Email'),
                    const SizedBox(height: Layout.s14),
                    _settings(context),
                    const SizedBox(height: Layout.s14),
                    _logout(context),
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

  Widget _profileHeader(AppState state) {
    return Row(
      children: <Widget>[
        const UserAvatar(size: Layout.avatarSizeProfile, color: Colors.white, iconColor: AppColors.orange),
        const SizedBox(width: Layout.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(state.userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: Layout.fsName, fontWeight: FontWeight.w600)),
              const SizedBox(height: Layout.s2),
              Text(state.phoneNumber, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const NotificationButton(dark: true),
      ],
    );
  }

  Widget _notice(IconData icon, String title, String description, String action) {
    return SoftCard(
      radius: Layout.cardRadiusMd,
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OrangeCircleIcon(icon: icon, size: 34, iconSize: 18),
          const SizedBox(width: Layout.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: Layout.s4),
                Text(description, style: const TextStyle(fontSize: Layout.fsBodySmall, color: AppColors.muted, height: 1.2)),
                const SizedBox(height: Layout.s2),
                Text(action, style: const TextStyle(fontSize: 13, color: AppColors.linkBlue, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.close_rounded, size: 22, color: AppColors.muted),
        ],
      ),
    );
  }

  Widget _settings(BuildContext context) {
    const List<_ProfileItem> primary = <_ProfileItem>[
      _ProfileItem('Profil Saya', Icons.person_outline_rounded),
      _ProfileItem('Keamanan Akun', Icons.verified_user_outlined),
      _ProfileItem('e-Statement', Icons.receipt_long_outlined),
      _ProfileItem('Pengaturan Limit dan Pembayaran', Icons.credit_card_outlined),
      _ProfileItem('Pengaturan BI-FAST', Icons.phonelink_setup_outlined),
      _ProfileItem('Pengaturan Umum', Icons.settings_outlined),
      _ProfileItem('Undang Teman', Icons.group_add_outlined),
      _ProfileItem('Pusat Bantuan', Icons.lightbulb_outline_rounded),
      _ProfileItem('Chat dengan SeaBank', Icons.chat_bubble_outline_rounded),
      _ProfileItem('Lokasi SeaBank', Icons.location_city_outlined),
      _ProfileItem('Beri Masukan', Icons.feedback_outlined),
    ];

    return SoftCard(
      radius: Layout.cardRadiusMd,
      padding: const EdgeInsets.symmetric(horizontal: Layout.s20),
      child: Column(
        children: <Widget>[
          ...primary.map((_ProfileItem item) => _settingRow(context, item)),
          _settingRow(context, const _ProfileItem('Developer Settings', Icons.developer_mode_rounded), developer: true),
        ],
      ),
    );
  }

  Widget _settingRow(BuildContext context, _ProfileItem item, {bool developer = false}) {
    return InkWell(
      onTap: () {
        if (developer) {
          context.push('/developer-settings');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.label} dipilih')));
        }
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.line))),
        child: Row(
          children: <Widget>[
            Icon(item.icon, size: 24, color: developer ? AppColors.orange : AppColors.ink),
            const SizedBox(width: Layout.s18),
            Expanded(
              child: Text(item.label, style: TextStyle(fontSize: 15, fontWeight: developer ? FontWeight.w600 : FontWeight.w400, color: developer ? AppColors.orange : null)),
            ),
            const Icon(Icons.chevron_right_rounded, size: 24, color: AppColors.muted),
          ],
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return SoftCard(
      radius: Layout.cardRadiusXs,
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Log Out', style: TextStyle(fontSize: 18)),
          content: const Text('Anda akan keluar dari sesi demo lokal ini.', style: TextStyle(fontSize: 14)),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal', style: TextStyle(fontSize: 14))),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Log Out', style: TextStyle(fontSize: 14))),
          ],
        ),
      ),
      child: const SizedBox(height: 56, child: Center(child: Text('Log Out', style: TextStyle(color: AppColors.orange, fontSize: 16, fontWeight: FontWeight.w700)))),
    );
  }
}

class _ProfileItem {
  const _ProfileItem(this.label, this.icon);
  final String label;
  final IconData icon;
}
