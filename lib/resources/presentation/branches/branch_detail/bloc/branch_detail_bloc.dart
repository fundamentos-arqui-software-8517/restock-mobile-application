import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/presentation/branches/branch_detail/bloc/branch_detail_event.dart';
import 'package:restock/resources/presentation/branches/branch_detail/bloc/branch_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class BranchDetailBloc extends Bloc<BranchDetailEvent, BranchDetailState> {
  BranchDetailBloc({required this.branchFacadeService})
      : super(const BranchDetailState()) {
    on<BranchDetailFetched>(_onFetched);
  }

  final BranchFacadeService branchFacadeService;

  Future<void> _onFetched(
    BranchDetailFetched event,
    Emitter<BranchDetailState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final branch = await branchFacadeService.getBranchById(event.branchId);
      emit(state.copyWith(status: Status.success, branch: branch));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }
}