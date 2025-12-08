class TransactionModel {
  final String title;
  final String subtitle;
  final double value;
  final bool isNegative;

  TransactionModel({
    required this.title,
    required this.subtitle,
    required this.value,
    this.isNegative = true,
  });
}