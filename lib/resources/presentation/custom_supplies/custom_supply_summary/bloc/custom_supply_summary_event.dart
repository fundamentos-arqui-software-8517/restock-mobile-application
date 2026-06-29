import 'package:restock/resources/domain/entities/custom_supply.dart';

abstract class CustomSupplySummaryEvent {
  const CustomSupplySummaryEvent();
}

class CustomSupplySummaryStarted extends CustomSupplySummaryEvent {
  const CustomSupplySummaryStarted({
    required this.customSupplyId,
    this.initialCustomSupply,
  });

  final String customSupplyId;
  final CustomSupply? initialCustomSupply;
}
