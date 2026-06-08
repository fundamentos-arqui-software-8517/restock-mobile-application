class Supply {
  const Supply({
    required this.supplyId,
    required this.name,
    required this.description,
    required this.category,
    required this.isPerishable,
  });

  final String supplyId;

  final String name;

  final String description;

  final String category;

  final bool isPerishable;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Supply && other.supplyId == supplyId;
  }

  @override
  int get hashCode => supplyId.hashCode;
}
