class ScaleStatus {
  const ScaleStatus({
    required this.code,
    required this.weight,
    required this.humidity,
    required this.temperature,
    required this.uptime,
  });

  final String code;
  final double weight;
  final int humidity;
  final int temperature;
  final String uptime;
}