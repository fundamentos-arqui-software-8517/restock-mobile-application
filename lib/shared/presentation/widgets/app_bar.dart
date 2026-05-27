import 'package:flutter/material.dart';

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
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () {
                // Acción estática temporal
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFE24B4A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(
            right: 20,
          ),
          child: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF2A3550),
              backgroundImage: NetworkImage(
                'https://pbs.twimg.com/profile_images/1481345033878085634/r4uZxGeb_400x400.jpg',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
