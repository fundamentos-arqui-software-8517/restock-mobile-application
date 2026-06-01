import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_event.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// Bloc for managing the state of the branch list.
class BranchListBloc
    extends Bloc<BranchListEvent, BranchListState> {

  /// Creates a new instance of [BranchListBloc].
  BranchListBloc({
    required this.branchFacadeService,
  }) : super(const BranchListState()) {
    on<GetBranches>(_onLoadBranches);
  }

  final BranchFacadeService branchFacadeService;

  /// Handles the [GetBranches] event to load the list of branches.
  /// Emits a loading state, then attempts to fetch branches from the service.
  Future<void> _onLoadBranches(
    GetBranches event,
    Emitter<BranchListState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final branches =
          await branchFacadeService.getBranchesByAccountId();

      emit(
        state.copyWith(
          status: Status.success,
          branches: branches,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Failed to load branches',
        ),
      );
    }
  }
}