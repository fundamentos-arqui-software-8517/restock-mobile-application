import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/batch.dart';

/// A custom form field widget for selecting a batch to transfer in the [BatchTransferForm]. It displays a trigger that shows the selected batch's code and stock information, and when tapped, it expands to show a searchable list of batches to choose from. The user can search for batches by their code, and select one to update the form state. It also handles the display of error messages if the selection is invalid.
class BatchTransferBatchesField extends StatefulWidget {
  const BatchTransferBatchesField({
    super.key,
    required this.batches,
    required this.value,
    required this.enabled,
    required this.errorText,
    required this.onChanged,
  });

  final List<Batch> batches;
  final Batch? value;
  final bool enabled;
  final String? errorText;
  final ValueChanged<Batch> onChanged;

  @override
  State<BatchTransferBatchesField> createState() =>
      _BatchTransferBatchesFieldState();
}

/// A custom dropdown field for selecting a batch to transfer in the [BatchTransferForm]. It displays a trigger that shows the selected batch's code and stock information, and when tapped, it expands to show a searchable list of batches to choose from. The user can search for batches by their code, and select one to update the form state. It also handles the display of error messages if the selection is invalid.
/// The field is designed to provide a user-friendly interface for selecting batches, with smooth animations and clear visual feedback for the selected batch and any errors. It manages its own internal state for the search query and the open/closed state of the dropdown, while communicating the selected batch back to the parent form through the `onChanged` callback.
class _BatchTransferBatchesFieldState
    extends State<BatchTransferBatchesField>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late List<Batch> _filtered;
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  late AnimationController _animCtrl;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _filtered = widget.batches;
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
      _filtered = widget.batches
          .where(
            (s) =>
        s.code.toLowerCase().contains(q),

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

  void _select(Batch supply) {
    widget.onChanged(supply);
    setState(() => _open = false);
    _animCtrl.reverse();
    _searchFocus.unfocus();
    _searchCtrl.clear();
    setState(() => _filtered = widget.batches);
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
          const Text(
            'BATCH TO TRANSFER',
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
            _BatchAvatar(batch: widget.value),
            const SizedBox(width: 12),
            Expanded(child: _BatchLabel(value: widget.value)),
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
                    s.customSupplyId == widget.value?.customSupplyId;
                return _BatchTile(
                  batch: s,
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

/// The avatar shown in the trigger of the [BatchTransferBatchesField], which displays an icon with different colors based on whether a batch is selected or not.
class _BatchAvatar extends StatelessWidget {
  const _BatchAvatar({required this.batch});
  final Batch? batch;

  @override
  Widget build(BuildContext context) {
    final sel = batch != null;
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

/// The label shown in the trigger of the [BatchTransferBatchesField], which displays the selected batch's code and stock information, or a placeholder if no batch is selected.
class _BatchLabel extends StatelessWidget {
  const _BatchLabel({required this.value});
  final Batch? value;

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return const Text(
        'SELECT A BATCH',
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
          value!.code,
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
          '${value!.currentStock} · ${value!.unitMeasurement}',
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

/// A single batch item in the dropdown list of the [BatchTransferBatchesField].
class _BatchTile extends StatelessWidget {
  const _BatchTile({
    required this.batch,
    required this.isSelected,
    required this.onTap,
  });
  final Batch batch;
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
                      batch.code,
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
                      '${batch.currentStock} · ${batch.unitMeasurement}',
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
