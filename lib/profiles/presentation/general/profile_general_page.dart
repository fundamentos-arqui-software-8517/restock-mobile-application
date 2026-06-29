import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_state.dart';
import 'package:restock/resources/presentation/branches/widgets/active_branch_card.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';

class ProfileGeneralPage extends StatefulWidget {
  const ProfileGeneralPage({super.key});

  @override
  State<ProfileGeneralPage> createState() => _ProfileGeneralPageState();
}

class _ProfileGeneralPageState extends State<ProfileGeneralPage> {
  String? _storedBranchId;
  String? _selectedBranchId;
  bool _hasLoadedSelectedBranch = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedSelectedBranch) return;

    _hasLoadedSelectedBranch = true;
    _loadSelectedBranch();
  }

  Future<void> _loadSelectedBranch() async {
    final selectedBranchId = await context
        .read<BranchFacadeService>()
        .getActiveBranchId();

    if (!mounted) return;
    setState(() {
      _storedBranchId = selectedBranchId;
      _selectedBranchId = selectedBranchId;
    });
  }

  void _selectBranch(Branch branch) {
    setState(() => _selectedBranchId = branch.branchId);
  }

  Future<void> _showBranchPicker(List<Branch> branches) async {
    final selectedBranch = await showModalBottomSheet<Branch>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ACTIVE BRANCH',
                style: TextStyle(
                  color: textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: branches.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    final isSelected = branch.branchId == _selectedBranchId;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        branch.name,
                        style: const TextStyle(
                          color: textTertiary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        branch.fullAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: green)
                          : null,
                      onTap: () => Navigator.of(context).pop(branch),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selectedBranch == null) return;
    _selectBranch(selectedBranch);
  }

  Future<void> _savePreferences(String branchId) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      await context.read<BranchFacadeService>().setActiveBranchId(branchId);

      if (!mounted) return;
      setState(() {
        _storedBranchId = branchId;
        _selectedBranchId = branchId;
        _isSaving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preferences saved')));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save preferences')),
      );
    }
  }

  void _discardChanges() {
    setState(() => _selectedBranchId = _storedBranchId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchListBloc, BranchListState>(
      builder: (context, state) {
        final branches = _selectableBranches(state.branches);
        final selectedBranch = _selectedBranch(branches);
        final hasSelectedBranch = selectedBranch != null;
        final hasChanges = _selectedBranchId != _storedBranchId;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
          children: [
            ActiveBranchCard(
              isLoading: state.status == Status.loading,
              branch: selectedBranch,
              onTap: branches.isEmpty
                  ? null
                  : () => _showBranchPicker(branches),
            ),
            const SizedBox(height: 28),
            _PreferencesButton(
              label: 'Discard Changes',
              isOutlined: true,
              onPressed: hasChanges && !_isSaving ? _discardChanges : null,
            ),
            const SizedBox(height: 12),
            _PreferencesButton(
              label: _isSaving ? 'Saving...' : 'Save Preferences',
              onPressed: hasSelectedBranch && !_isSaving
                  ? () => _savePreferences(selectedBranch.branchId)
                  : null,
            ),
          ],
        );
      },
    );
  }

  List<Branch> _selectableBranches(List<Branch> branches) {
    final activeBranches = branches
        .where((branch) => branch.status.toLowerCase() == 'active')
        .toList();

    return activeBranches.isEmpty ? branches : activeBranches;
  }

  Branch? _selectedBranch(List<Branch> branches) {
    if (branches.isEmpty) return null;

    return branches.cast<Branch?>().firstWhere(
      (branch) => branch?.branchId == _selectedBranchId,
      orElse: () => branches.first,
    );
  }
}

class _PreferencesButton extends StatelessWidget {
  const _PreferencesButton({
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final backgroundColor = isOutlined ? Colors.white : const Color(0xFF007A4D);
    final foregroundColor = isOutlined
        ? (isDisabled ? textSecondary : textTertiary)
        : Colors.white;

    return SizedBox(
      height: 58,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isOutlined
                  ? (isDisabled ? const Color(0xFFD0D2D8) : textSecondary)
                  : const Color(0xFF007A4D),
              width: isOutlined ? 1.6 : 1,
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
