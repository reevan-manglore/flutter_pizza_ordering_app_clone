import 'package:flutter/material.dart';

import '../models/topping_item.dart';

class ToppingsProvider with ChangeNotifier {
  final List<ToppingItem> _toppings = [
    ToppingItem(
      id: "123",
      toppingName: "Mushrooms",
      toppingImageUrl:
          "https://media.istockphoto.com/photos/button-mushrooms-picture-id1276597176?b=1&k=20&m=1276597176&s=170667a&w=0&h=7Uikv2zeui91Ei3bWFcz1S7ODCJC6nxyoZ87PHRBjlQ=",
      toppingPrice: 60,
      isVegan: true,
    ),
    ToppingItem(
      id: "456",
      toppingName: "Tomato",
      toppingImageUrl:
          "https://media.istockphoto.com/photos/two-tomato-slices-isolated-on-white-picture-id1325880683?b=1&k=20&m=1325880683&s=170667a&w=0&h=A_QJAWrUjnWsxbQiaD6-A4Av16hGLciBbBqdWRFhM90=",
      toppingPrice: 40,
      isVegan: true,
    ),
    ToppingItem(
      id: "789",
      toppingName: "Onion",
      toppingImageUrl:
          "https://media.istockphoto.com/photos/golden-onions-on-rustic-wooden-background-picture-id480134211?b=1&k=20&m=480134211&s=170667a&w=0&h=OPKNVD97M6k27V0kY-ih-rbaBuA6a2JRkjJeyrFg9d8=",
      toppingPrice: 10,
      isVegan: true,
    ),
    ToppingItem(
      id: "114",
      toppingName: "Capsicum",
      toppingImageUrl:
          "https://media.istockphoto.com/photos/colorful-peppers-picture-id153564958?b=1&k=20&m=153564958&s=170667a&w=0&h=kGyZux_Gk_hMlW3Y7xf3E420Cs3V9_JTJS75PKDI_t8=",
      toppingPrice: 25,
      isVegan: true,
    ),
    ToppingItem(
      id: "176",
      toppingName: "Jalapeno",
      toppingImageUrl:
          "https://media.istockphoto.com/photos/jalapenos-chili-peppers-or-mexican-chili-peppers-on-white-picture-id1267152775?b=1&k=20&m=1267152775&s=170667a&w=0&h=yxT55cvhMkVIS5LYh0MHglZyKfcRpYOqYl885hVzkzQ=",
      toppingPrice: 25,
      isVegan: true,
    ),
    ToppingItem(
      id: "186",
      toppingName: "Pepper Barbeque Chicken",
      toppingImageUrl:
          "https://media.istockphoto.com/photos/chiken-wings-in-a-skillet-picture-id1317148250?b=1&k=20&m=1317148250&s=170667a&w=0&h=IoWobRLcvNEYUzneWrNdDmY4bjPZbm0aLo6C8I-44cw=",
      toppingPrice: 85,
      isVegan: false,
    ),
    ToppingItem(
      id: "136",
      toppingName: "Chicken Suasage",
      toppingImageUrl:
          "https://media.istockphoto.com/photos/tasty-sausage-picture-id492964557?b=1&k=20&m=492964557&s=170667a&w=0&h=AHN3NqQj1QWwlEInb_Et5nkrnAKh-KEja1zfulBUPeI=",
      toppingPrice: 75,
      isVegan: false,
    ),
    ToppingItem(
      id: "126",
      toppingName: "Chicken Tikka",
      toppingImageUrl:
          "https://media.istockphoto.com/photos/closeup-of-freshly-grilled-chicken-tikka-masala-kebabs-on-skewers-picture-id519749260?b=1&k=20&m=519749260&s=170667a&w=0&h=Qg_f5v9FMVaTIJI38ms2pshstb3sWELT4WU9x21OJwA=",
      toppingPrice: 85,
      isVegan: false,
    ),
    ToppingItem(
      id: "116",
      toppingName: "Nashvile Chicken",
      toppingImageUrl:
          "https://media.istockphoto.com/photos/fried-chicken-picture-id494788722?b=1&k=20&m=494788722&s=170667a&w=0&h=CxrlaV7tL1QdkDVyxvFF2UeO7U6U1h5lLDzoz6H0pD8=",
      toppingPrice: 110,
      isVegan: false,
    ),
  ];

  List<ToppingItem> get veganToppings {
    return _toppings.where((element) => element.isVegan == true).toList();
  }

  List<ToppingItem> get nonVeganToppings {
    return _toppings.where((element) => element.isVegan == false).toList();
  }

  ToppingItem findToppingByName(String name) {
    return _toppings.firstWhere((element) => element.toppingName == name);
  }

  ToppingItem findToppingById(String id) {
    return _toppings.firstWhere((element) => element.id == id);
  }
}
