import 'package:flutter/cupertino.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';

class ScaleBars extends StatelessWidget {
  const ScaleBars({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        4,
            (index) => Expanded(
          child: Container(
            height: 8,
            margin: EdgeInsets.only(right: index == 3 ? 0 : 7),
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}