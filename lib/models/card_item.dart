class CardItem {
  String name;
  int billDate;
  int dueDate;
  DateTime? lastPaidOn;
  bool isPaid;

  CardItem({
    required this.name,
    required this.billDate,
    required this.dueDate,
    this.lastPaidOn,
    this.isPaid = false,
  });
}
