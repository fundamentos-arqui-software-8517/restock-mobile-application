import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/blocs/create_and_edit_branch_bloc.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/blocs/create_and_edit_branch_event.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/blocs/create_and_edit_branch_state.dart';

import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/image_picker_field.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';
import 'package:restock/shared/presentation/widgets/text_field.dart';

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

class _CreateAndEditBranchViewState extends State<_CreateAndEditBranchView> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateOrRegionController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _descriptionController = TextEditingController();

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

  void _dispatch(CreateAndEditBranchEvent event) =>
      context.read<CreateAndEditBranchBloc>().add(event);

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
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: SafeArea(
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
                          state.isEditing ? 'Edit Branch' : 'Create New Branch',
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImagePickerField(
                        imageUrl: widget.branch?.imageUrl,
                        onImagePicked: (xFile) =>
                            _dispatch(CreateAndEditBranchImageChanged(xFile)),
                      ),
                      const SizedBox(height: 16),

                      RestockTextField(
                        controller: _nameController,
                        hint: 'BRANCH NAME',
                        onChanged: (v) =>
                            _dispatch(CreateAndEditBranchNameChanged(v)),
                      ),
                      const SizedBox(height: 10),

                      RestockTextField(
                        controller: _addressController,
                        hint: 'STREET ADDRESS',
                        onChanged: (v) =>
                            _dispatch(CreateAndEditBranchAddressChanged(v)),
                      ),
                      const SizedBox(height: 10),

                      RestockTextField(
                        controller: _stateOrRegionController,
                        hint: 'STATE / REGION',
                        onChanged: (v) => _dispatch(
                          CreateAndEditBranchStateOrRegionChanged(v),
                        ),
                      ),
                      const SizedBox(height: 10),

                      RestockTextField(
                        controller: _cityController,
                        hint: 'CITY',
                        onChanged: (v) =>
                            _dispatch(CreateAndEditBranchCityChanged(v)),
                      ),
                      const SizedBox(height: 10),

                      RestockTextField(
                        controller: _countryController,
                        hint: 'COUNTRY',
                        onChanged: (v) =>
                            _dispatch(CreateAndEditBranchCountryChanged(v)),
                      ),
                      const SizedBox(height: 10),

                      RestockTextField(
                        controller: _descriptionController,
                        hint: 'DESCRIPTION',
                        maxLines: 3,
                        onChanged: (v) =>
                            _dispatch(CreateAndEditBranchDescriptionChanged(v)),
                      ),
                      const SizedBox(height: 24),

                      RestockButton(
                        text: widget.branch != null
                            ? 'Save Changes'
                            : 'Save Branch',
                        onPressed: () => context
                            .read<CreateAndEditBranchBloc>()
                            .add(const CreateAndEditBranchSubmitted()),
                      ),
                      const SizedBox(height: 24),
                    ],
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
