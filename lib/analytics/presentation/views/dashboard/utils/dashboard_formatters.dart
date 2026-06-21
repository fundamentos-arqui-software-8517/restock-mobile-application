String formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String formatDecimal(double value) => value.toStringAsFixed(1);

String formatStock(double value) => value.toStringAsFixed(2);
