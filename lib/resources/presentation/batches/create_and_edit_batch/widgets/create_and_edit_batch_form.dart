import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_bloc.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_event.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_state.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/widgets/create_and_edit_batch_date_field.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/widgets/create_and_edit_batch_supply_field.dart';
import 'package:restock/shared/presentation/widgets/batch_form_text_field.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';

import '../../../../../shared/presentation/widgets/restock_outlined_button.dart';

class CreateAndEditBatchForm extends StatefulWidget {
  const CreateAndEditBatchForm({super.key});

  @override
  State<CreateAndEditBatchForm> createState() => _CreateAndEditBatchFormState();
}

class _CreateAndEditBatchFormState extends State<CreateAndEditBatchForm> {
  final _codeController = TextEditingController();
  final _stockController = TextEditingController(text: '0');
  final _expirationDateController = TextEditingController();

  void _dispatch(CreateAndEditBatchEvent event) =>
      context.read<CreateAndEditBatchBloc>().add(event);

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateAndEditBatchBloc>().state;
    _codeController.text = state.code;
    _stockController.text = state.currentStock.isEmpty
        ? '0'
        : state.currentStock;
    _expirationDateController.text = state.expirationDate;

    if (state.currentStock.isEmpty) {
      _dispatch(const CreateAndEditBatchCurrentStockChanged('0'));
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _stockController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAndEditBatchBloc, CreateAndEditBatchState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == Status.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to register batch'),
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
                  child:
                      BlocBuilder<
                        CreateAndEditBatchBloc,
                        CreateAndEditBatchState
                      >(
                        buildWhen: (prev, curr) =>
                            prev.isEditing != curr.isEditing,
                        builder: (context, state) => Text(
                          state.isEditing ? 'Edit Batch' : 'Add New Batch',
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
                child:
                    BlocBuilder<
                      CreateAndEditBatchBloc,
                      CreateAndEditBatchState
                    >(
                      builder: (context, state) {
                        final isLoading = state.isLoading;
                        final isLoadingSupplies =
                            state.suppliesStatus == Status.loading;

                        return SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: [
                              BatchTextField(
                                controller: _codeController,
                                label: 'BATCH NAME',
                                enabled: !isLoading,
                                errorText: state.codeError,
                                onChanged: (value) => _dispatch(
                                  CreateAndEditBatchCodeChanged(value),
                                ),
                              ),
                              const SizedBox(height: 12),
                              CreateAndEditBatchSupplyField(
                                supplies: state.customSupplies,
                                value: state.selectedCustomSupply,
                                enabled: !isLoading && !isLoadingSupplies,
                                errorText: state.supplyError,
                                onChanged: (supply) => _dispatch(
                                  CreateAndEditBatchSupplyChanged(supply),
                                ),
                              ),
                              if (state.suppliesStatus == Status.failure) ...[
                                const SizedBox(height: 8),
                                Text(
                                  state.errorMessage ??
                                      'Failed to load supplies',
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              BatchTextField(
                                controller: _stockController,
                                label: state.isEditing
                                    ? 'STOCK (UNITS)'
                                    : 'INITIAL STOCK (UNITS)',
                                keyboardType: TextInputType.number,
                                enabled: !isLoading,
                                errorText: state.currentStockError,
                                onChanged: (value) => _dispatch(
                                  CreateAndEditBatchCurrentStockChanged(value),
                                ),
                              ),
                              const SizedBox(height: 12),
                              CreateAndEditBatchDateField(
                                controller: _expirationDateController,
                                enabled: !isLoading,
                                errorText: state.expirationDateError,
                                onChanged: (value) => _dispatch(
                                  CreateAndEditBatchExpirationDateChanged(
                                    value,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34),
                              RestockButton(
                                text: isLoading
                                    ? state.isEditing
                                          ? 'Updating...'
                                          : 'Adding...'
                                    : state.isEditing
                                    ? 'Update Batch'
                                    : 'Add Batch',
                                isLoading: isLoading,
                                enabled: !isLoading,
                                onPressed: () => _dispatch(
                                  const CreateAndEditBatchSubmitted(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              RestockOutlinedButton(
                                text: 'Cancel',
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
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
