import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/presentation/branches/branch_status/bloc/branch_status_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_status/bloc/branch_status_event.dart';
import 'package:restock/resources/presentation/branches/branch_status/bloc/branch_status_state.dart';
import 'package:restock/resources/presentation/branches/branch_status/widgets/branch_status_toggle.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/blocs/create_and_edit_branch_bloc.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/blocs/create_and_edit_branch_event.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/blocs/create_and_edit_branch_state.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/widgets/branch_labeled_text_field.dart';

import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/image_picker_field.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';

/// A widget that provides a form for creating or editing a branch, including fields for name, address, state/region, city, country, description, and an image picker. It listens to the [CreateAndEditBranchBloc] for state changes and dispatches events when the user interacts with the form.
class CreateAndEditBranchPage extends StatelessWidget {
  const CreateAndEditBranchPage({super.key, this.branch});

  final Branch? branch;

  @override
  Widget build(BuildContext context) {
    return _CreateAndEditBranchView(branch: branch);
  }
}

class _CreateAndEditBranchView extends StatefulWidget {
  const _CreateAndEditBranchView({this.branch});

  final Branch? branch;

  @override
  State<_CreateAndEditBranchView> createState() =>
      _CreateAndEditBranchViewState();
}

/// State class for [_CreateAndEditBranchView] that manages the form controllers and listens to the [CreateAndEditBranchBloc] for handling form submission and displaying success or error messages.
/// It initializes the form fields with the existing branch data if editing, and dispatches events to the bloc when the user changes any field or submits the form.
class _CreateAndEditBranchViewState extends State<_CreateAndEditBranchView> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateOrRegionController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _dispatch(CreateAndEditBranchEvent event) =>
      context.read<CreateAndEditBranchBloc>().add(event);

  Future<bool> _showDeactivateConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Deactivate Branch?',
              style: TextStyle(
                color: Color(0xFF0D1B2A),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: const Text(
              'This branch will no longer be visible to managers. You can reactivate it at any time.',
              style: TextStyle(
                color: Color(0xFF5A6472),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF5A6472)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text(
                  'Deactivate',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _stateOrRegionController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final branch = widget.branch;

    if (branch != null) {
      _nameController.text = branch.name;
      _addressController.text = branch.address.address;
      _stateOrRegionController.text = branch.address.regionOrState;
      _cityController.text = branch.address.city;
      _countryController.text = branch.address.country;
      _descriptionController.text = branch.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAndEditBranchBloc, CreateAndEditBranchState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == Status.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        }
      },
      child: BlocListener<UpdateBranchStatusBloc, UpdateBranchStatusState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == Status.success) {
            final branchStatus = context
                .read<CreateAndEditBranchBloc>()
                .state
                .branchStatus;
            Navigator.of(context).pop(branchStatus);
          } else if (state.status == Status.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to update status'),
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
                          CreateAndEditBranchBloc,
                          CreateAndEditBranchState
                        >(
                          buildWhen: (prev, curr) =>
                              prev.isEditing != curr.isEditing,
                          builder: (context, state) => Text(
                            state.isEditing
                                ? 'Edit Branch'
                                : 'Create New Branch',
                            style: const TextStyle(
                              color: Color(0xFF0D1B2A),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
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
                          CreateAndEditBranchBloc,
                          CreateAndEditBranchState
                        >(
                          buildWhen: (prev, curr) =>
                              prev.isEditing != curr.isEditing ||
                              prev.branchStatus != curr.branchStatus ||
                              prev.status != curr.status ||
                              prev.submitted != curr.submitted ||
                              prev.name != curr.name ||
                              prev.address != curr.address ||
                              prev.stateOrRegion != curr.stateOrRegion ||
                              prev.city != curr.city ||
                              prev.country != curr.country,
                          builder: (context, state) {
                            final isActive = state.branchStatus == 'active';
                            final isEditing = state.isEditing;
                            final isLoading = state.status == Status.loading;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImagePickerField(
                                  imageUrl: widget.branch?.imageUrl,
                                  enabled: isActive && !isLoading,
                                  onImagePicked: isActive && !isLoading
                                      ? (xFile) => _dispatch(
                                          CreateAndEditBranchImageChanged(
                                            xFile,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                BranchLabeledTextField(
                                  controller: _nameController,
                                  label: 'BRANCH NAME',
                                  errorText: state.nameError,
                                  enabled: isActive && !isLoading,
                                  onChanged: isActive && !isLoading
                                      ? (v) => _dispatch(
                                          CreateAndEditBranchNameChanged(v),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 10),

                                BranchLabeledTextField(
                                  controller: _addressController,
                                  label: 'STREET ADDRESS',
                                  errorText: state.addressError,
                                  enabled: isActive && !isLoading,
                                  onChanged: isActive && !isLoading
                                      ? (v) => _dispatch(
                                          CreateAndEditBranchAddressChanged(v),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 10),

                                BranchLabeledTextField(
                                  controller: _stateOrRegionController,
                                  label: 'STATE / REGION',
                                  errorText: state.stateOrRegionError,
                                  enabled: isActive && !isLoading,
                                  onChanged: isActive && !isLoading
                                      ? (v) => _dispatch(
                                          CreateAndEditBranchStateOrRegionChanged(
                                            v,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 10),

                                BranchLabeledTextField(
                                  controller: _cityController,
                                  label: 'CITY',
                                  errorText: state.cityError,
                                  enabled: isActive && !isLoading,
                                  onChanged: isActive && !isLoading
                                      ? (v) => _dispatch(
                                          CreateAndEditBranchCityChanged(v),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 10),

                                BranchLabeledTextField(
                                  controller: _countryController,
                                  label: 'COUNTRY',
                                  errorText: state.countryError,
                                  enabled: isActive && !isLoading,
                                  onChanged: isActive && !isLoading
                                      ? (v) => _dispatch(
                                          CreateAndEditBranchCountryChanged(v),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 10),

                                BranchLabeledTextField(
                                  controller: _descriptionController,
                                  label: 'DESCRIPTION (OPTIONAL)',
                                  maxLines: 3,
                                  enabled: isActive && !isLoading,
                                  onChanged: isActive && !isLoading
                                      ? (v) => _dispatch(
                                          CreateAndEditBranchDescriptionChanged(
                                            v,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 24),

                                if (isEditing) ...[
                                  BlocBuilder<
                                    UpdateBranchStatusBloc,
                                    UpdateBranchStatusState
                                  >(
                                    builder: (context, statusState) {
                                      return BranchStatusToggle(
                                        isActive: isActive,
                                        isLoading:
                                            statusState.status ==
                                            Status.loading,
                                        onChanged: (value) async {
                                          if (!value) {
                                            final confirm =
                                                await _showDeactivateConfirmDialog();
                                            if (!confirm) return;
                                          }
                                          _dispatch(
                                            CreateAndEditBranchStatusChanged(
                                              value,
                                            ),
                                          );
                                          if (!context.mounted) return;
                                          context
                                              .read<UpdateBranchStatusBloc>()
                                              .add(
                                                UpdateBranchStatusSubmitted(
                                                  branchId: state.branchId!,
                                                  status: value
                                                      ? 'active'
                                                      : 'inactive',
                                                ),
                                              );
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                RestockButton(
                                  text: isLoading
                                      ? isEditing
                                            ? 'Saving...'
                                            : 'Creating...'
                                      : isEditing
                                      ? 'Save Changes'
                                      : 'Save Branch',
                                  isLoading: isLoading,
                                  enabled: isActive && !isLoading,
                                  onPressed: isActive && !isLoading
                                      ? () => _dispatch(
                                          const CreateAndEditBranchSubmitted(),
                                        )
                                      : null,
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
      ),
    );
  }
}
