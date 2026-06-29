import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/batches/batch_transfer/bloc/batch_transfer_event.dart';
import 'package:restock/resources/presentation/batches/batch_transfer/bloc/batch_transfer_state.dart';
import 'package:restock/resources/presentation/batches/batch_transfer/widgets/batch_transfer_batches_field.dart';
import 'package:restock/resources/presentation/batches/batch_transfer/widgets/batch_transfer_branches_field.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/batch_form_text_field.dart';

import '../../../../../shared/presentation/widgets/restock_outlined_button.dart';
import '../../../../../shared/presentation/widgets/restok_button.dart';
import '../bloc/batch_transfer_bloc.dart';

/// Form used to transfer batches between supplies. It is used in the [BatchTransferPage].
/// It is a [StatefulWidget] because it needs to manage the state of the form fields and the transfer process.
class BatchTransferForm extends StatefulWidget {
  const BatchTransferForm({super.key});

  @override
  State<BatchTransferForm> createState() => _BatchTransferForm();
}

/// State class for the [BatchTransferForm]. It manages the state of the form fields and handles the logic for transferring batches between supplies. It interacts with the [BatchTransferBloc] to dispatch events and update the state accordingly.
class _BatchTransferForm extends State<BatchTransferForm> {
  /// Helper method to dispatch events to the [BatchTransferBloc]. It takes an event as a parameter and adds it to the bloc.
  final _stockToTransferController = TextEditingController(text: '0');

  /// Defines the things done when the widget is first created. It initializes the text controller with the current quantity to transfer from the bloc state. If the quantity is empty, it sets it to '0' and dispatches an event to update the bloc state accordingly.
  @override
  void initState() {
    super.initState();
    final state = context.read<BatchTransferBloc>().state;
    _stockToTransferController.text =
        state.quantityToTransfer.toString().isEmpty
        ? '0'
        : state.quantityToTransfer.toString();

    if (state.quantityToTransfer.toString().isEmpty) {
      _dispatch(const BatchTransferStockToTransferChanged(0));
    }
  }

  /// Dispatches an event to the [BatchTransferBloc]. It takes a [BatchTransferEvent] as a parameter and adds it to the bloc, allowing the bloc to handle the event and update its state accordingly.
  void _dispatch(BatchTransferEvent event) =>
      context.read<BatchTransferBloc>().add(event);

  /// Disposes the controllers when the widget is removed from the widget tree to free up resources.
  @override
  void dispose() {
    _stockToTransferController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BatchTransferBloc, BatchTransferState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status || prev.submitted != curr.submitted,
      listener: (context, state) {
        if (state.submitted && state.status == Status.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.messageError ?? 'Failed to transfer batch'),
            ),
          );
        }
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.68,
        minChildSize: 0.55,
        maxChildSize: 0.92,
        builder: (context, scrollController) => SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFC6C7CC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: BlocBuilder<BatchTransferBloc, BatchTransferState>(
                    builder: (context, state) => Text(
                      'Transfer Batch Stock',
                      style: const TextStyle(
                        color: Color(0xFF171A22),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: BlocBuilder<BatchTransferBloc, BatchTransferState>(
                  builder: (context, state) {
                    final isLoading = state.isLoading;

                    final isLoadingBatches =
                        state.batchesStatus == Status.loading;

                    final isLoadingBranches =
                        state.branchesStatus == Status.loading;

                    return SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          // The batch selection field for the batch transfer.
                          // It uses the [BatchTransferBranchesField] widget to display a dropdown field for the user to select the destination branch for the batch transfer. The field is enabled or disabled based on the loading state of the bloc, and it displays an error message if there is an error in loading the branches.
                          BatchTransferBranchesField(
                            branches: state.branches,
                            value: state.destinationBranch,
                            enabled: !isLoading && !isLoadingBranches,
                            errorText: state.branchError,
                            onChanged: (branch) => _dispatch(
                              BatchTransferDestinationBranchChanged(branch),
                            ),
                            label: 'DESTINATION ZONE',
                          ),

                          // Displays an error message if there is an error in loading the branches.
                          // It checks if the branches status is failure and if so, it shows a red error message with the error details or a default message if the error details are not available.
                          if (state.branchesStatus == Status.failure) ...[
                            const SizedBox(height: 8),
                            Text(
                              state.messageError ?? 'Failed to load branches',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ],

                          const SizedBox(height: 12),

                          // The batch selection field for the batch transfer.
                          // It uses the [BatchTransferBatchesField] widget to display a dropdown field for the user to select the batch to transfer. The field is enabled or disabled based on the loading state
                          BatchTransferBatchesField(
                            batches: state.batches,
                            value: state.selectedBatch,
                            enabled: !isLoading && !isLoadingBatches,
                            errorText: state.batchError,
                            onChanged: (batch) => _dispatch(
                              BatchTransferBatchSelectedChanged(batch),
                            ),
                          ),

                          // Displays an error message if there is an error in loading the batches.
                          if (state.batchesStatus == Status.failure) ...[
                            const SizedBox(height: 8),
                            Text(
                              state.messageError ?? 'Failed to load batches',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ],

                          const SizedBox(height: 12),

                          // The quantity field for the batch transfer.
                          // It uses the [BatchTextField] widget to display a text field for the user to input the quantity of stock to transfer. The field is enabled or disabled based on the loading state of the bloc, and it displays an error message if there is an error in the quantity input.
                          BatchTextField(
                            controller: _stockToTransferController,
                            label: 'QUANTITY',
                            enabled: !isLoading,
                            errorText: state.transferredQuantityError,
                            onChanged: (value) => _dispatch(
                              BatchTransferStockToTransferChanged(
                                double.tryParse(value) ?? 0,
                              ),
                            ),
                          ),

                          const SizedBox(height: 34),

                          // The confirm transfer button for the batch transfer.
                          // It uses the [RestockButton] widget to display a button for the user to confirm the batch transfer.
                          // The button is enabled or disabled based on the loading state of the bloc, and it shows a loading state when the transfer is in progress. When the button is pressed, it
                          RestockButton(
                            text: isLoading
                                ? 'Transferring...'
                                : 'Confirm Transfer',
                            isLoading: isLoading,
                            enabled: !isLoading,
                            onPressed: () =>
                                _dispatch(const BatchTransferSubmitted()),
                          ),

                          const SizedBox(height: 16),

                          // The cancel button for the batch transfer.
                          RestockOutlinedButton(
                            text: 'Cancel',
                            onPressed: () => Navigator.of(context).pop(false),
                            isLoading: isLoading,
                          ),

                          const SizedBox(height: 28),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
