import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/branch.dart';

/// Custom dropdown field for selecting branches in the batch transfer form. It displays a list of branches and allows the user to search and select one. It also shows the selected branch with its name and address, and handles the open/close state of the dropdown panel with animations.
/// It is used in the [BatchTransferForm] to select the origin and destination branches for the batch transfer process.
class BatchTransferBranchesField extends StatefulWidget {
  const BatchTransferBranchesField({
    super.key,
    required this.branches,
    required this.value,
    required this.enabled,
    required this.errorText,
    required this.onChanged,
    required this.label,
  });

  final List<Branch> branches;
  final Branch? value;
  final bool enabled;
  final String? errorText;
  final ValueChanged<Branch> onChanged;
  final String label;

  @override
  State<BatchTransferBranchesField> createState() =>
      _BatchTransferBranchesFieldState();
}

/// State class for the [BatchTransferBranchesField]. It manages the open/close state of the dropdown panel, the filtered list of branches based on the search query, and handles the selection of a branch. It also manages the animations for expanding and collapsing the dropdown panel.
/// It interacts with the parent widget through the [onChanged] callback to notify when a branch is selected, and it updates its internal state to reflect the current selection and search results.
class _BatchTransferBranchesFieldState
    extends State<BatchTransferBranchesField>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late List<Branch> _filtered;
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  late AnimationController _animCtrl;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _filtered = widget.branches;
    _searchCtrl.addListener(_onSearch);
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _expandAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = widget.branches
          .where(
            (s) =>
            s.name.toLowerCase().contains(q),

      ).toList();
    });
  }

  void _toggle() {
    if (!widget.enabled) return;
    setState(() => _open = !_open);
    if (_open) {
      _animCtrl.forward();
      Future.delayed(
        const Duration(milliseconds: 200),
            () => _searchFocus.requestFocus(),
      );
    } else {
      _animCtrl.reverse();
      _searchFocus.unfocus();
    }
  }

  void _select(Branch branch) {
    widget.onChanged(branch);
    setState(() => _open = false);
    _animCtrl.reverse();
    _searchFocus.unfocus();
    _searchCtrl.clear();
    setState(() => _filtered = widget.branches);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label, // 'ORIGIN ZONE' OR 'DESTINATION ZONE',
            style: TextStyle(
              color: Color(0xFF7A808A),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          _buildTrigger(),
          SizeTransition(sizeFactor: _expandAnim, child: _buildPanel()),
          if (widget.errorText != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrigger() {
    final hasValue = widget.value != null;
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: hasValue ? const Color(0xFFFAFFFE) : Colors.white,
          borderRadius: _open
              ? const BorderRadius.vertical(top: Radius.circular(12))
              : BorderRadius.circular(12),
          border: Border.all(
            color: _open
                ? const Color(0xFF1D9E75)
                : hasValue
                ? const Color(0xFFB7E2D1)
                : const Color(0xFFC9CED8),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            _BranchAvatar(branch: widget.value),
            const SizedBox(width: 12),
            Expanded(child: _BranchLabel(value: widget.value)),
            AnimatedRotation(
              turns: _open ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _open
                    ? const Color(0xFF1D9E75)
                    : const Color(0xFF9AA3AF),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border(
          left: BorderSide(color: Color(0xFF1D9E75), width: 0.5),
          right: BorderSide(color: Color(0xFF1D9E75), width: 0.5),
          bottom: BorderSide(color: Color(0xFF1D9E75), width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              style: const TextStyle(fontSize: 13, color: Color(0xFF171A22)),
              decoration: InputDecoration(
                hintText: 'SEARCH...',
                hintStyle: const TextStyle(
                  color: Color(0xFF9AA3AF),
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF9AA3AF),
                  size: 18,
                ),
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFE1E6EC),
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFE1E6EC),
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF1D9E75),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8EBF0)),
          // List
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: _filtered.isEmpty
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'NO RESULTS',
                style: TextStyle(
                  color: Color(0xFF9AA3AF),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: _filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, i) {
                final s = _filtered[i];
                final isSelected =
                    s.branchId == widget.value?.branchId;
                return _BranchTile(
                  branch: s,
                  isSelected: isSelected,
                  onTap: () => _select(s),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying the avatar/icon of a branch in the dropdown trigger. It changes its appearance based on whether a branch is selected or not, using different colors and icons to indicate the selection state. It is used in the [BatchTransferBranchesField] to visually represent the currently selected branch.
class _BranchAvatar extends StatelessWidget {
  const _BranchAvatar({required this.branch});
  final Branch? branch;

  @override
  Widget build(BuildContext context) {
    final sel = branch != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: sel ? const Color(0xFFD8F1E7) : const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: 20,
        color: sel ? const Color(0xFF1B5E45) : const Color(0xFF6B7280),
      ),
    );
  }
}

/// Widget for displaying the label of a branch in the dropdown trigger. It shows the name and address of the selected branch, or a placeholder text if no branch is selected. It is used in the [BatchTransferBranchesField] to provide information about the currently selected branch in the dropdown trigger.
class _BranchLabel extends StatelessWidget {
  const _BranchLabel({required this.value});
  final Branch? value;

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return Text(
        'SELECT A BRANCH',
        style: TextStyle(
          color: Color(0xFF9AA3AF),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value!.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF171A22),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${value!.address}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Widget for displaying each branch option in the dropdown panel. It shows the name and address of the branch, and indicates whether it is currently selected or not with different colors and icons. It is used in the [BatchTransferBranchesField] to display the list of branches in the dropdown panel and allow the user to select one.
class _BranchTile extends StatelessWidget {
  const _BranchTile({
    required this.branch,
    required this.isSelected,
    required this.onTap,
  });
  final Branch branch;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F5EE) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFFB7E2D1) : Colors.transparent,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFD8F1E7)
                      : const Color(0xFFF3F5F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isSelected ? Icons.check_rounded : Icons.inventory_2_outlined,
                  size: 17,
                  color: isSelected
                      ? const Color(0xFF1B5E45)
                      : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF171A22),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${branch.address}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
