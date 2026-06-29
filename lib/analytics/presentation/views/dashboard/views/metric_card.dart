import 'package:flutter/cupertino.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';
import 'dashboard_card.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.caption,
    required this.child,
    this.value,
    this.suffix,
    this.badge,
  });

  final String title;
  final String caption;
  final Widget child;
  final String? value;
  final String? suffix;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      height: 216,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: muted,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: mint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: green,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
              ),
            )
          else
            RichText(
              text: TextSpan(
                text: value,
                style: const TextStyle(
                  color: ink,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
                children: [
                  TextSpan(
                    text: suffix,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          child,
          const SizedBox(height: 12),
          Text(
            caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: green,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
