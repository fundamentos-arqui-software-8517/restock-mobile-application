import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/application/batch_facade_service.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/presentation/batches/batch_detail/widgets/batch_detail_content.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_bloc.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_event.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/widgets/create_and_edit_batch_form.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';

class BatchDetailScreen extends StatelessWidget {
  const BatchDetailScreen({super.key, required this.batch});

  final Batch batch;

  static const _ink = Color(0xFF0D1B2A);
  static const _muted = Color(0xFF5A6472);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _ink),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Batch Detail',
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: batch.id.isEmpty
          ? const Center(
              child: Text('Batch unavailable', style: TextStyle(color: _muted)),
            )
          : Column(
              children: [
                Expanded(child: BatchDetailContent(batch: batch)),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                    child: RestockButton(
                      text: 'Edit Batch',
                      onPressed: () => _openEditBatchSheet(context),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _openEditBatchSheet(BuildContext context) async {
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider<CreateAndEditBatchBloc>(
        create: (_) => CreateAndEditBatchBloc(
          batchFacadeService: serviceLocator<BatchFacadeService>(),
          customSupplyFacadeService:
              serviceLocator<CustomSupplyFacadeService>(),
          batch: batch,
        )..add(const CreateAndEditBatchStarted()),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const CreateAndEditBatchForm(),
        ),
      ),
    );

    if (updated == true && context.mounted) {
      context.pop(true);
    }
  }
}
