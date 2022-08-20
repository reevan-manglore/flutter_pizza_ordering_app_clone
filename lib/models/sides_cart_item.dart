import '../providers/sides_item_provider.dart';

class SidesCartItem {
  final SidesItemProvider side;
  final int itemPrice;

  SidesCartItem(this.side, this.itemPrice);
  @override
  bool operator ==(Object? other) {
    if (other is! SidesCartItem) {
      return false;
    }
    if (other.side.id != side.id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode => side.hashCode ^ itemPrice.hashCode;
}
