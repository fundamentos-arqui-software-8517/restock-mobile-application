import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/analytics/application/analytics_facade_service.dart';
import 'package:restock/analytics/presentation/views/dashboard/bloc/dashboard_event.dart';
import 'package:restock/analytics/presentation/views/dashboard/bloc/dashboard_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({required this.analyticsFacadeService})
    : super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshed>(_onRefreshed);
  }

  final AnalyticsFacadeService analyticsFacadeService;

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onRefreshed(
    DashboardRefreshed event,
    Emitter<DashboardState> emit,
  ) async {
    await _load(emit, refresh: true);
  }

  Future<void> _load(
    Emitter<DashboardState> emit, {
    bool refresh = false,
  }) async {
    emit(
      state.copyWith(
        status: refresh && state.hasData ? Status.success : Status.loading,
        clearError: true,
      ),
    );

    try {
      final overview = await analyticsFacadeService.getOverview();
      emit(DashboardState.fromOverview(overview));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'Failed to load overview analytics',
        ),
      );
    }
  }
}
