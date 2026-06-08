import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/presentation/branches/branch_status/bloc/branch_status_event.dart';
import 'package:restock/resources/presentation/branches/branch_status/bloc/branch_status_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// Bloc for updating the status of a branch.
class UpdateBranchStatusBloc
    extends Bloc<UpdateBranchStatusEvent, UpdateBranchStatusState> {
  UpdateBranchStatusBloc({required this.branchFacadeService})
    : super(const UpdateBranchStatusState()) {
    on<UpdateBranchStatusSubmitted>(_onSubmitted);
  }

  /// The service used to interact with branch data.
  final BranchFacadeService branchFacadeService;

  /// Handles the submission of a branch status update.
  Future<void> _onSubmitted(
    UpdateBranchStatusSubmitted event,
    Emitter<UpdateBranchStatusState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await branchFacadeService.updateBranchStatus(
        event.branchId,
        event.status,
      );
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }
}
