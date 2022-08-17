import '../providers/pizza_item_provider.dart';

import './topping_item.dart';

class PizzaCartItem {
  final PizzaItemProvider pizza;
  final PizzaSizes selectedSize;
  int itemPrice = 0;
  List<ToppingItem>? extraToppings;
  Map<String, ToppingItem>? toppingReplacement;
  /*
    Here toppingReplacement map will contain data as follwing 
    {
      "toppingToBeReplaced":ToppingProvider,
      "replacementTopping":ToppingProvider
    }
  */

  PizzaCartItem({
    required this.pizza,
    required this.selectedSize,
    required this.itemPrice,
    this.extraToppings,
    this.toppingReplacement,
  });

  @override
  bool operator ==(Object? other) {
    //if other item is not of type PizzaCartItem then retrun false
    if (other is! PizzaCartItem) {
      return false;
    }

    //if pizzaId is not same or selectedSize!=other.selectedSize then return false
    if (pizza.id != other.pizza.id || selectedSize != other.selectedSize) {
      return false;
    }

    //if any one of topping is null and other extratopping not null then return false
    if ((extraToppings == null && other.extraToppings != null) ||
        (other.extraToppings == null && extraToppings != null)) {
      return false;
    }

    //if any both of extraToppings and other.extraToppings are not null then move to this block of code
    if (extraToppings != null && other.extraToppings != null) {
      if (extraToppings!.length != other.extraToppings!.length) {
        return false;
      }
      /*
      if any of one of topping between other.toppings and extraToppings is not null then every()
      - gives false we negotaiate this inorder to execute return false  block
      */
      if (!other.extraToppings!.every(
        (element) => extraToppings!.contains(element),
      )) {
        return false;
      }
    }

    //if both toppingReplacment and other.toppingReplacement both are null then return true
    if ((toppingReplacement == other.toppingReplacement) &&
        toppingReplacement == null) {
      return true;
    }

    if ((toppingReplacement == null && other.toppingReplacement != null) ||
        (other.toppingReplacement == null && toppingReplacement != null)) {
      return false;
    }

    /*
   if all element toppingReplacement[keys] != other.toppingReplacement[keys] 
    - then this every() function returns false 
   */
    final isSame = toppingReplacement!.keys.every((element) =>
        toppingReplacement![element] == other.toppingReplacement![element]);

    if (!isSame) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return pizza.hashCode ^
        selectedSize.hashCode ^
        extraToppings.hashCode ^
        toppingReplacement.hashCode;
  }
}
