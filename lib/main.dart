import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/menu_provider.dart';
import 'providers/toppings_provider.dart';
import './providers/cart_provider.dart';

import 'screens/home_page/home_page.dart';
import 'screens/customization_screen/customization_screen.dart';
import 'screens/category_overview_screen/category_overview_screen.dart';

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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorSchemeSeed: Color(0xFF006491),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => HomePage(),
          CustomizationScreen.routeName: (context) => CustomizationScreen(),
          CategoryOverviewScreen.routeName: (context) =>
              CategoryOverviewScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}
