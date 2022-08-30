import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/menu_provider.dart';
import 'providers/toppings_provider.dart';
import './providers/cart_provider.dart';
import './providers/offer_provider.dart';
import 'providers/vegan_preferance_provider.dart';

import 'screens/home_page/home_page.dart';
import 'screens/customization_screen/customization_screen.dart';
import 'screens/item_display_screen/items_by_category_display_screen.dart';
import 'screens/cart_screen/cart_screen.dart';
import 'screens/item_display_screen/items_by_offer_display_screen.dart';
import 'screens/offer_picking_screen/offer_picking_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToppingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VeganPreferanceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OfferProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF006491),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => HomePage(),
          CustomizationScreen.routeName: (context) =>
              const CustomizationScreen(),
          ItemsByCategoryDisplayScreen.routeName: (context) =>
              const ItemsByCategoryDisplayScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          ItemsByOfferDisplayScreen.routeName: (context) =>
              const ItemsByOfferDisplayScreen(),
          OfferPickingScreen.routeName: (context) => const OfferPickingScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}
