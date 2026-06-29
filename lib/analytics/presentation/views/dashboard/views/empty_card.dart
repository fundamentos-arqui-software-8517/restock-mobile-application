import 'package:flutter/cupertino.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/dashboard_card.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      height: 86,
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: muted,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}