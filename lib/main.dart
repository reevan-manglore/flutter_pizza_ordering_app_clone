import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:pizza_app/firebase_options.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:tuple/tuple.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
import 'screens/user_account_info_screen/user_account_info_screen.dart';
import 'screens/user_account_info_screen/add_new_address_screen.dart';
import 'screens/order_view_screen/order_history_view_screen.dart';

import 'helpers/loading_screen.dart';
import 'screens/cart_screen/payment_success.dart';
import 'screens/cart_screen/payment_failure.dart';

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
        ChangeNotifierProxyProvider<UserAccountProvider, MenuProvider>(
          create: (context) => MenuProvider(),
          update: (context, userAccount, previousMenuVal) {
            if (previousMenuVal == null) {
              return MenuProvider()
                ..setUserLocation(
                  userAccount.addressToDeliver.geoHash,
                  latitude: userAccount.addressToDeliver.latitude,
                  longitude: userAccount.addressToDeliver.longitude,
                );
            } else {
              return previousMenuVal
                ..setUserLocation(
                  userAccount.addressToDeliver.geoHash,
                  latitude: userAccount.addressToDeliver.latitude,
                  longitude: userAccount.addressToDeliver.longitude,
                );
            }
          },
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
        Provider(
          create: (context) => Razorpay(),
          dispose: (context, value) => value.clear(),
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
                //since we are definig home route so flutter will give error if one declare "/" route
                // '/': (context) => const HomePage(),
                WelcomePage.routeName: (context) => const WelcomePage(),
                LoginScreen.routeName: (context) => const LoginScreen(),
                SignupScreen.routeName: (context) => const SignupScreen(),
                UserRegistrationScreen.routeName: (context) =>
                    const UserRegistrationScreen(),
                UserAccountInfoScreen.routeName: (context) =>
                    const UserAccountInfoScreen(),
                AddNewAdressScreen.routeName: (context) =>
                    const AddNewAdressScreen(),
                CustomizationScreen.routeName: (context) =>
                    const CustomizationScreen(),
                ItemsByCategoryDisplayScreen.routeName: (context) =>
                    const ItemsByCategoryDisplayScreen(),
                CartScreen.routeName: (context) => const CartScreen(),
                ItemsByOfferDisplayScreen.routeName: (context) =>
                    const ItemsByOfferDisplayScreen(),
                OfferPickingScreen.routeName: (context) =>
                    const OfferPickingScreen(),
                OrderHistoryViewScreen.routeName: (context) =>
                    OrderHistoryViewScreen(),
                PaymentSuccess.routeName: (context) => const PaymentSuccess(),
                PaymentFailure.routeName: (context) => const PaymentFailure(),
              },
            );
          }),
    );
  }
}
