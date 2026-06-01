import 'package:flutter/material.dart';

/// A widget that represents a card with a dotted border, used to indicate the option to add a new custom supply in the [CustomSupplyListView].
class DottedAddCard extends StatelessWidget {
  const DottedAddCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDF7ED), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2E6F40),
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF2E6F40),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              'Add Custom\nSupply',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2E6F40),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}