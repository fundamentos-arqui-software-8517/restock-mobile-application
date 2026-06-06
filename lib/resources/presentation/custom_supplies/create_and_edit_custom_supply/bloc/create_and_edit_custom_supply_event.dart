import 'package:image_picker/image_picker.dart';
import 'package:restock/resources/domain/entities/supply.dart';

abstract class CreateCustomSupplyEvent {
  const CreateCustomSupplyEvent();
}

class CreateCustomSupplyNameChanged extends CreateCustomSupplyEvent {
  const CreateCustomSupplyNameChanged(this.name);
  final String name;
}

class CreateCustomSupplySupplyChanged extends CreateCustomSupplyEvent {
  const CreateCustomSupplySupplyChanged(this.supply);
  final Supply supply;
}

class CreateCustomSupplyMinimumStockChanged extends CreateCustomSupplyEvent {
  const CreateCustomSupplyMinimumStockChanged(this.minimumStock);
  final String minimumStock;
}

class CreateCustomSupplyMaximumStockChanged extends CreateCustomSupplyEvent {
  const CreateCustomSupplyMaximumStockChanged(this.maximumStock);
  final String maximumStock;
}

class CreateCustomSupplyUnitPriceChanged extends CreateCustomSupplyEvent {
  const CreateCustomSupplyUnitPriceChanged(this.unitPrice);
  final String unitPrice;
}

class CreateCustomSupplyCurrencyChanged extends CreateCustomSupplyEvent {
  const CreateCustomSupplyCurrencyChanged(this.currency);
  final String currency;
}

class CreateCustomSupplyUnitChanged extends CreateCustomSupplyEvent {
  const CreateCustomSupplyUnitChanged(this.unit);
  final String unit;
}

class CreateCustomSupplyDescriptionChanged extends CreateCustomSupplyEvent {
  const CreateCustomSupplyDescriptionChanged(this.description);
  final String description;
}

class CreateCustomSupplyImageChanged extends CreateCustomSupplyEvent {
  const CreateCustomSupplyImageChanged(this.image);
  final XFile? image;
}

class CreateCustomSupplySubmitted extends CreateCustomSupplyEvent {
  const CreateCustomSupplySubmitted();
}
