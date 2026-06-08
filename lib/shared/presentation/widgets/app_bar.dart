import 'package:flutter/material.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_event.dart';
import 'package:restock/profiles/presentation/widgets/profile_avatar.dart';

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
            SizedBox(height: 2),
            Text(
              'MAIN BRANCH',
              style: TextStyle(
                color: Color(0xFF8899AA),
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
      ),
      actions: [
        const NotificationButton(hasUnread: true),
        const SizedBox(width: 4),
        const ProfileAvatar(
          imageUrl: 'https://pbs.twimg.com/profile_images/1481345033878085634/r4uZxGeb_400x400.jpg',
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
