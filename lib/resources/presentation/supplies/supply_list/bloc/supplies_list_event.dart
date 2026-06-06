/// Event for the SuppliesListBloc
abstract class SuppliesListEvent {
  const SuppliesListEvent();
}

/// Event to get the list of supplies
class GetSupplies extends SuppliesListEvent {
  const GetSupplies();
}