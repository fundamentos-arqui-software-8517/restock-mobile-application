import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_summary/bloc/custom_supply_summary_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_summary/bloc/custom_supply_summary_state.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_summary/widgets/custom_supply_content.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CustomSupplySummaryScreen extends StatelessWidget {
  const CustomSupplySummaryScreen({super.key});

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
          'Custom Supply Detail',
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocBuilder<CustomSupplySummaryBloc, CustomSupplySummaryState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2D6A4F)),
            );
          }

          if (state.status != Status.success || state.customSupply == null) {
            return Center(
              child: Text(
                state.message ?? 'Custom supply unavailable',
                style: const TextStyle(color: _muted),
              ),
            );
          }

          return CustomSupplySummaryContent(supply: state.customSupply!);
        },
      ),
    );
  }
}
