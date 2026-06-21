abstract class CustomSupplyListEvent {
  const CustomSupplyListEvent();
}

class GetCustomSuppliesByBranchId extends CustomSupplyListEvent {
  const GetCustomSuppliesByBranchId();
}

class CustomSupplySearchChanged extends CustomSupplyListEvent {
  const CustomSupplySearchChanged(this.query);

  final String query;
}
