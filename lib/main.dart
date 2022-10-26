import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:pizza_app/firebase_options.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:tuple/tuple.dart';

import './providers/user_account_provider.dart';
import './providers/menu_provider.dart';
import 'providers/toppings_provider.dart';
import './providers/cart_provider.dart';
import './providers/offer_provider.dart';
import 'providers/vegan_preferance_provider.dart';

import 'screens/auth_screen/welcome_screen.dart';
import 'screens/auth_screen/login_screen.dart';
import 'screens/auth_screen/signup_screen.dart';
import "screens/auth_screen/user_registration_screen.dart";
import 'screens/home_page/home_page.dart';
import 'screens/customization_screen/customization_screen.dart';
import 'screens/item_display_screen/items_by_category_display_screen.dart';
import 'screens/cart_screen/cart_screen.dart';
import 'screens/item_display_screen/items_by_offer_display_screen.dart';
import 'screens/offer_picking_screen/offer_picking_screen.dart';

import 'helpers/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserAccountProvider(),
        ),
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
        StreamProvider.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: Selector2<User?, UserAccountProvider, Tuple3<User?, bool, bool>>(
          selector: (_, user, userAccount) =>
              Tuple3(user, userAccount.isRegisterd, userAccount.isLoading),
          builder: (context, value, _) {
            final user = value.item1;
            final isRegisterd = value.item2;
            final isLoading = value.item3;
            late Widget _pageToRender;
            if (isLoading) {
              _pageToRender = const LoadingScreen();
            } else if (user == null) {
              _pageToRender = const WelcomePage();
            } else if (!isRegisterd) {
              _pageToRender = const UserRegistrationScreen();
            } else {
              _pageToRender = const HomePage();
            }

            return MaterialApp(
              title: 'Pizza App',
              theme: ThemeData(
                colorSchemeSeed: const Color(0xFF006491),
                useMaterial3: true,
              ),
              home: _pageToRender,
              routes: {
                // '/': (context) => const HomePage(),
                WelcomePage.routeName: (context) => const WelcomePage(),
                LoginScreen.routeName: (context) => const LoginScreen(),
                SignupScreen.routeName: (context) => const SignupScreen(),
                UserRegistrationScreen.routeName: (context) =>
                    const UserRegistrationScreen(),
                CustomizationScreen.routeName: (context) =>
                    const CustomizationScreen(),
                ItemsByCategoryDisplayScreen.routeName: (context) =>
                    const ItemsByCategoryDisplayScreen(),
                CartScreen.routeName: (context) => const CartScreen(),
                ItemsByOfferDisplayScreen.routeName: (context) =>
                    const ItemsByOfferDisplayScreen(),
                OfferPickingScreen.routeName: (context) =>
                    const OfferPickingScreen(),
              },
              // initialRoute: '/',
              // initialRoute: AuthenticationPage.routeName,
            );
          }),
    );
  }
}
