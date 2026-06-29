import 'package:flutter/material.dart';
import 'package:restock/analytics/presentation/views/dashboard/utils/scale_status.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/dashboard_card.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/reading_row.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';
import 'online_badge.dart';

class ScaleCard extends StatelessWidget {
  const ScaleCard({super.key, required this.scale});

  final ScaleStatus scale;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  scale.code,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const OnlineBadge(),
            ],
          ),
          const SizedBox(height: 20),
          ReadingRow(label: 'Weight', value: '${scale.weight}kg'),
          const SizedBox(height: 10),
          ReadingRow(label: 'Humidity', value: '${scale.humidity}%'),
          const SizedBox(height: 10),
          ReadingRow(label: 'Temp', value: '${scale.temperature}°C'),
          const Spacer(),
          const Divider(color: line, height: 1),
          const SizedBox(height: 8),
          Text(
            'UPTIME: ${scale.uptime}',
            style: const TextStyle(
              color: muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
