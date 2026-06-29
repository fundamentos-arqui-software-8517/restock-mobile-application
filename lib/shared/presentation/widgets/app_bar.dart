import 'package:flutter/material.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_event.dart';
import 'package:restock/injections.dart';
import 'package:restock/profiles/presentation/widgets/profile_avatar.dart';
import 'package:restock/shared/infrastructure/services/auth_status_notifier.dart';

/// A custom AppBar widget for the Restock application, featuring a distinctive design and layout.
///
/// This AppBar includes a title, subtitle, notification icon with badge, and a user profile avatar.
class RestockAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RestockAppBar({super.key});

  static const Color _bg = Color(0xFF151C2A);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RESTOCK',
              style: TextStyle(
                color: Color(0xFF4ECCA3),
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      actions: [
        const NotificationButton(hasUnread: true),
        const SizedBox(width: 4),
        PopupMenuButton<_AccountAction>(
          tooltip: 'Account menu',
          offset: const Offset(0, 48),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (action) {
            if (action == _AccountAction.signOut) {
              _confirmSignOut(context);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _AccountAction.signOut,
              child: Row(
                children: [
                  Icon(Icons.logout_rounded, color: Color(0xFFB42318)),
                  SizedBox(width: 12),
                  Text(
                    'Sign out',
                    style: TextStyle(
                      color: Color(0xFFB42318),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          child: const ProfileAvatar(
            imageUrl:
                'https://pbs.twimg.com/profile_images/1481345033878085634/r4uZxGeb_400x400.jpg',
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final shouldSignOut = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E4EA),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE4E1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFB42318),
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Sign out?',
                style: TextStyle(
                  color: Color(0xFF151C2A),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your session will close on this device. You can sign in again anytime.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7B7F88),
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB42318),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF151C2A),
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Keep working',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldSignOut != true) return;
    await serviceLocator<AuthStatusNotifier>().signOut();
  }
}

enum _AccountAction { signOut }
