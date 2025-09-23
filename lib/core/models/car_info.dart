class CarInfo {
  final String id;
  final String carNumber;
  final DateTime? expirationDateITP;
  final DateTime? expirationDateRCA;
  final DateTime? expirationDateCASCO;
  final DateTime? expirationDateRovinieta;
  final DateTime? expirationDateTahograf;

  CarInfo({
    required this.id,
    required this.carNumber,
    this.expirationDateITP,
    this.expirationDateRCA,
    this.expirationDateCASCO,
    this.expirationDateRovinieta,
    this.expirationDateTahograf,
  });
}
