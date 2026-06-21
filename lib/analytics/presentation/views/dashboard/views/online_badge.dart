import 'package:flutter/cupertino.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';

class OnlineBadge extends StatelessWidget {
  const OnlineBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: mint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'ONLINE',
        style: TextStyle(
          color: green,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}