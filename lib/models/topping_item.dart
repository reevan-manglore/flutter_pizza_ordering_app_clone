class ToppingItem {
  final String id;
  final String toppingName;
  final String toppingImageUrl;
  final int toppingPrice;
  final bool isVegan;

  ToppingItem({
    required this.id,
    required this.toppingName,
    required this.toppingImageUrl,
    required this.toppingPrice,
    required this.isVegan,
  });

  @override
  bool operator ==(Object other) {
    if (other is! ToppingItem) {
      return false;
    }
    if (other.id != id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode => id.hashCode;
}
