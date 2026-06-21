import 'package:flutter/material.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';

class DashboardWelcome extends StatelessWidget {
  const DashboardWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Restock',
          style: TextStyle(
            color: ink,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Here is your inventory overview.',
          style: TextStyle(
            color: muted,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
