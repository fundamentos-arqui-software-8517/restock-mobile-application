import 'package:restock/resources/domain/entities/custom_supply.dart';

sealed class CreateAndEditBatchEvent {
  const CreateAndEditBatchEvent();
}

class CreateAndEditBatchStarted extends CreateAndEditBatchEvent {
  const CreateAndEditBatchStarted();
}

class CreateAndEditBatchSupplyChanged extends CreateAndEditBatchEvent {
  const CreateAndEditBatchSupplyChanged(this.customSupply);

  final CustomSupply customSupply;
}

class CreateAndEditBatchCodeChanged extends CreateAndEditBatchEvent {
  const CreateAndEditBatchCodeChanged(this.code);

  final String code;
}

class CreateAndEditBatchCurrentStockChanged extends CreateAndEditBatchEvent {
  const CreateAndEditBatchCurrentStockChanged(this.currentStock);

  final String currentStock;
}

class CreateAndEditBatchExpirationDateChanged extends CreateAndEditBatchEvent {
  const CreateAndEditBatchExpirationDateChanged(this.expirationDate);

  final String expirationDate;
}

class CreateAndEditBatchSubmitted extends CreateAndEditBatchEvent {
  const CreateAndEditBatchSubmitted();
}
