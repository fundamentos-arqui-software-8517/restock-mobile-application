import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_bloc.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_card.dart';

class BatchListView extends StatelessWidget {
  const BatchListView({
    super.key,
    required this.batches,
    required this.isSearching,
  });

  final List<Batch> batches;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    if (batches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Text(
            isSearching ? 'No matching batches' : 'No batches available',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: batches.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final batch = batches[index];
        return BatchCard(
          batch: batch,
          onTap: () async {
            final updated = await context.push<bool>(
              '/inventory/${batch.id}',
              extra: batch,
            );
            if (updated == true && context.mounted) {
              context.read<BatchListBloc>().add(const BatchListStarted());
            }
          },
        );
      },
    );
  }
}
