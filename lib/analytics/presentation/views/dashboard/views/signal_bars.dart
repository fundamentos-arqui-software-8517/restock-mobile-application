import 'package:flutter/cupertino.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';

class SignalBars extends StatelessWidget {
  const SignalBars({super.key});

  @override
  Widget build(BuildContext context) {
    const heights = [18.0, 26.0, 14.0, 34.0, 25.0];
    return SizedBox(
      height: 34,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final height in heights)
            Container(
              width: 10,
              height: height,
              margin: const EdgeInsets.only(right: 7),
              decoration: BoxDecoration(
                color: mint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}