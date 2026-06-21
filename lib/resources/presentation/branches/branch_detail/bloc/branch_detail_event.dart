import 'package:restock/resources/domain/entities/branch.dart';

abstract class BranchDetailEvent {}

class BranchDetailFetched extends BranchDetailEvent {
  BranchDetailFetched(this.branchId, {this.initialBranch});

  final String branchId;
  final Branch? initialBranch;
}
