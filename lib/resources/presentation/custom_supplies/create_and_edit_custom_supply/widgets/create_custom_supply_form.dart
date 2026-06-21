import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/bloc/create_and_edit_custom_supply_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/bloc/create_and_edit_custom_supply_event.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/bloc/create_and_edit_custom_supply_state.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/widgets/custom_supply_labeled_text_field.dart';
import 'package:restock/shared/presentation/widgets/select_field.dart';
import 'package:restock/resources/presentation/supplies/supply_list/widgets/supply_selector_field.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/image_picker_field.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';
import 'package:restock/shared/presentation/widgets/text_field.dart';

class CreateCustomSupplyForm extends StatefulWidget {
  const CreateCustomSupplyForm({super.key});

  @override
  State<CreateCustomSupplyForm> createState() => _CreateCustomSupplyFormState();
}

class _CreateCustomSupplyFormState extends State<CreateCustomSupplyForm> {
  static const _unitOptions = {
    'kg': 'Kilograms',
    'l': 'Liters',
    'dozen': 'Dozen',
    'g': 'Grams',
    'unit': 'Units',
  };

  final _nameController = TextEditingController();
  final _minimumController = TextEditingController();
  final _maximumController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _dispatch(CreateCustomSupplyEvent event) =>
      context.read<CreateCustomSupplyBloc>().add(event);

  @override
  void initState() {
    super.initState();

    final state = context.read<CreateCustomSupplyBloc>().state;
    _nameController.text = state.name;
    _minimumController.text = state.minimumStock;
    _maximumController.text = state.maximumStock;
    _priceController.text = state.unitPrice;
    _descriptionController.text = state.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minimumController.dispose();
    _maximumController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCustomSupplyBloc, CreateCustomSupplyState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == Status.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Failed to create custom supply',
              ),
            ),
          );
        }
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child:
                      BlocBuilder<
                        CreateCustomSupplyBloc,
                        CreateCustomSupplyState
                      >(
                        buildWhen: (prev, curr) =>
                            prev.isEditing != curr.isEditing,
                        builder: (context, state) => Text(
                          state.isEditing
                              ? 'Edit Custom Supply'
                              : 'New Custom Supply',
                          style: const TextStyle(
                            color: Color(0xFF0D1B2A),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      BlocBuilder<
                        CreateCustomSupplyBloc,
                        CreateCustomSupplyState
                      >(
                        builder: (context, state) {
                          final isLoading = state.status == Status.loading;
                          final hasInvalidStockRange =
                              state.submitted &&
                              int.tryParse(state.minimumStock) != null &&
                              int.tryParse(state.maximumStock) != null &&
                              int.parse(state.minimumStock) >=
                                  int.parse(state.maximumStock);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImagePickerField(
                                imageUrl: state.pictureUrl,
                                enabled: !isLoading,
                                onImagePicked: (image) => _dispatch(
                                  CreateCustomSupplyImageChanged(image),
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomSupplyLabeledTextField(
                                controller: _nameController,
                                label: 'SUPPLY NAME',
                                enabled: !isLoading,
                                errorText: state.nameError,
                                onChanged: (value) => _dispatch(
                                  CreateCustomSupplyNameChanged(value),
                                ),
                              ),
                              const SizedBox(height: 10),

                              SupplySelectorField(
                                label: 'SELECT SUPPLY',
                                value: state.supply,
                                enabled: !isLoading,
                                errorText: state.supplyError,
                                onChanged: (supply) {
                                  if (supply == null) return;
                                  _dispatch(
                                    CreateCustomSupplySupplyChanged(supply),
                                  );
                                },
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: CustomSupplyLabeledTextField(
                                      controller: _minimumController,
                                      label: 'MINIMUM STOCK',
                                      keyboardType: TextInputType.number,
                                      enabled: !isLoading,
                                      errorText: state.minimumStockError,
                                      onChanged: (value) => _dispatch(
                                        CreateCustomSupplyMinimumStockChanged(
                                          value,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomSupplyLabeledTextField(
                                      controller: _maximumController,
                                      label: 'MAXIMUM STOCK',
                                      keyboardType: TextInputType.number,
                                      enabled: !isLoading,
                                      errorText: state.maximumStockError,
                                      onChanged: (value) => _dispatch(
                                        CreateCustomSupplyMaximumStockChanged(
                                          value,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (hasInvalidStockRange) ...[
                                const SizedBox(height: 6),
                                const Text(
                                  'Minimum stock must be less than maximum stock.',
                                  style: TextStyle(
                                    color: Color(0xFFE24B4A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomSupplyLabeledTextField(
                                      controller: _priceController,
                                      label: 'UNIT PRICE',
                                      keyboardType: TextInputType.number,
                                      enabled: !isLoading,
                                      errorText: state.unitPriceError,
                                      onChanged: (value) => _dispatch(
                                        CreateCustomSupplyUnitPriceChanged(
                                          value,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SelectField(
                                      label: 'CURRENCY',
                                      value: state.currency,
                                      enabled: !isLoading,
                                      icon: Icons.payments_outlined,
                                      items: const ['PEN', 'USD', 'EUR'],
                                      onChanged: (value) {
                                        if (value == null) return;
                                        _dispatch(
                                          CreateCustomSupplyCurrencyChanged(
                                            value,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SelectField(
                                label: 'UNIT OF MEASURE',
                                value: state.unit,
                                enabled: !isLoading,
                                icon: Icons.straighten_outlined,
                                items: _unitOptions.keys.toList(),
                                itemLabel: (value) => _unitOptions[value]!,
                                onChanged: (value) {
                                  if (value == null) return;
                                  _dispatch(
                                    CreateCustomSupplyUnitChanged(value),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              RestockTextField(
                                controller: _descriptionController,
                                hint: 'DESCRIPTION',
                                maxLines: 3,
                                enabled: !isLoading,
                                errorText: state.descriptionError,
                                onChanged: (value) => _dispatch(
                                  CreateCustomSupplyDescriptionChanged(value),
                                ),
                              ),
                              const SizedBox(height: 24),
                              RestockButton(
                                text: isLoading
                                    ? state.isEditing
                                          ? 'Saving...'
                                          : 'Creating...'
                                    : state.isEditing
                                    ? 'Save Changes'
                                    : 'Create Supply',
                                isLoading: isLoading,
                                enabled: !isLoading,
                                onPressed: () => _dispatch(
                                  const CreateCustomSupplySubmitted(),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        },
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
