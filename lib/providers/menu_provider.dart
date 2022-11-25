import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:geoflutterfire/geoflutterfire.dart";
import "package:connectivity_plus/connectivity_plus.dart";

import '../models/restaurant.dart';

import './sides_item_provider.dart';
import './pizza_item_provider.dart';

class MenuProvider extends ChangeNotifier {
  List<PizzaItemProvider> _pizzas = [];
  List<SidesItemProvider> _sides = [];
  String? _userLocationHash;
  double? _userLatitude;
  double? _userLongitude;

  Restaurant? resturantAssigned;

  bool _isLoading = false;
  bool _hasError = true;
  String? _errMsg;
  DateTime? _timeDuringLastFetch; //inorder to avoid race conditons if any

  void setUserLocation(String location,
      {required double longitude, required double latitude}) {
    //if location passed as parameter is same as previous userLocation then do nothing just return
    if (location == _userLocationHash) return;
    _userLocationHash = location;
    _userLatitude = latitude;
    _userLongitude = longitude;
    /*when location changes then we will start to refetch the menu items
    based on user curent  location here is reseted _isLoading to false becuase
    i written condition in fetchAndSet products to just return if alerdy isLoading
    is true in order to avoid double fetching problem  which was happening during 
    app starts
    */

    _isLoading = false;
    fetchAndSetProducts();
  }

  String? get userLocation {
    return _userLocationHash;
  }

  List<PizzaItemProvider> get pizzas {
    return _pizzas;
  }

  List<SidesItemProvider> get sides {
    return _sides;
  }

  int get itemCount {
    return pizzas.length + sides.length;
  }

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  String? get errMsg => _errMsg;

  Future<DocumentSnapshot<Object?>?> _fetchNearbuyRestaurants() async {
    GeoFirePoint center = Geoflutterfire()
        .point(latitude: _userLatitude!, longitude: _userLongitude!);

    var collectionReference =
        FirebaseFirestore.instance.collection('restaurants');

    double radius = 8; //8km
    String field = 'location';

    Stream<List<DocumentSnapshot>> stream = Geoflutterfire()
        .collection(
          collectionRef: collectionReference,
        )
        .within(
          center: center,
          radius: radius,
          field: field,
          strictMode: true,
        );

    List<DocumentSnapshot> documents = await stream.first;
    if (documents.isEmpty) {
      return null;
    } else {
      return documents.first;
    }
  }

  Future<void> fetchAndSetProducts() async {
    if (_userLocationHash == null) return;
    if (_isLoading) return;
    try {
      final List<PizzaItemProvider> tempPizzaArr = [];
      final List<SidesItemProvider> tempSidesArr = [];
      _isLoading = true;
      _hasError = false; //if in case _hasError is true
      _errMsg = null;

      final _timeDuringThisFetch = DateTime.now(); //to avoid race conditons
      _timeDuringLastFetch = _timeDuringThisFetch; // to avoid race conditons

      final conectivityReult = await Connectivity().checkConnectivity();
      if (conectivityReult == ConnectivityResult.none) {
        throw const SocketException("Sorry internet connection not found");
      }

      /*
        here whenever we call notify listeners in middle of  build process i.e is during inital fetch
        (when home page is loaded) it requests the Flutter Framework to rebuild it 
        but Flutter is already in a build process. 
        here,so Flutter rejects the request and throws an exception.
        so inorder to prevent this exception we call addPostFrameCallback() is called
        inorder to ensure that closure. notifyListeners() will be executed after the build is complete.
        //correction here this just worked as i more developed the application i.e while added more features
        //i think this was caused dued to double fetching problem which i solved
      */
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   notifyListeners();
      // });
      notifyListeners();
      final resturant = await _fetchNearbuyRestaurants();
      if (resturant == null) {
        _pizzas = [];
        _sides = [];
        return;
      }
      resturantAssigned = Restaurant.fromMap(
          resturantId: resturant.id,
          data: resturant.data() as Map<String, dynamic>);

      final firestoreMenuInstance =
          FirebaseFirestore.instance.collection("menuItems");
      final itemsToFetch = resturantAssigned!.itemsAvailable
          .map((e) => firestoreMenuInstance.doc(e).get())
          .toList();
      final menuItems = await Future.wait(itemsToFetch);

      final uid = FirebaseAuth.instance.currentUser?.uid;
      final userSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      late List<dynamic>? userFavourites;
      //if in case faviourites field is not present than when referncing
      //faviourites field will throw array so i enclosed in try catch
      try {
        userFavourites = userSnapshot.data()?["favourites"] as List<dynamic>?;
      } catch (e) {
        userFavourites = null;
      }

      for (var element in menuItems) {
        final isItemUserFavourite = userFavourites == null
            ? false
            : userFavourites.contains(element.id);
        if (element.data()?["itemType"] == "pizza") {
          tempPizzaArr.add(PizzaItemProvider.fromMap(
              element.id, element.data()!,
              isFavourite: isItemUserFavourite));
        } else {
          tempSidesArr.add(SidesItemProvider.fromMap(
              element.id, element.data()!,
              isFavourite: isItemUserFavourite));
        }
      }
      /*if one more fetchAndSet  functions is invocated
        then timeOfThisFetch and _timeDuringLastFetch will
        not be same so by using this techniqe we will come
        to know if fetchAndSet is invocated multipple times.
        if its invocated then we will set results of 
        most recent function call to _pizzas and for _sides
      */
      if (_timeDuringThisFetch != _timeDuringLastFetch) return;

      _pizzas = tempPizzaArr;
      _sides = tempSidesArr;
    } on SocketException catch (e) {
      log("there was some problem in clients internet connection$e");
      _errMsg = e.message;
      _hasError = true;
    } on FirebaseException catch (e) {
      log("there was some problem while fetching data  $e");
      _errMsg = e.message;
      _hasError = true;
    } catch (e) {
      log("there was some error $e");
      _errMsg = e.toString();
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  PizzaItemProvider findPizzaById(String id) {
    return _pizzas.firstWhere((element) => element.id == id);
  }

  SidesItemProvider findSidesById(String id) {
    return _sides.firstWhere((element) => element.id == id);
  }

  List<PizzaItemProvider> findPizzas({
    bool veganOnly = false,
    bool nonVeganOnly = false,
    bool bestSellerOnly = false,
    bool sortByBestSeller = false,
  }) {
    List<PizzaItemProvider> filterdPizzas = _pizzas;
    if (veganOnly) {
      filterdPizzas =
          filterdPizzas.where((ele) => ele.isVegan == true).toList();
    }
    if (nonVeganOnly) {
      //if in case veg ony and nonVegOnly turned on then highest prority will be for vegOnly
      filterdPizzas = veganOnly
          ? filterdPizzas
          : filterdPizzas.where((ele) => ele.isVegan == false).toList();
    }
    if (bestSellerOnly) {
      filterdPizzas = filterdPizzas.where((ele) => ele.isBestSeller).toList();
    }
    if (sortByBestSeller) {
      filterdPizzas.sort((_, second) =>
          second.isBestSeller ? 1 : -1); //hack to sort by bestseller
    }
    return filterdPizzas;
  }

  List<SidesItemProvider> findSides(
      {SidesCategory? category,
      bool bestSellersOnly = false,
      bool veganOnly = false,
      bool sortByBestSeller = false}) {
    List<SidesItemProvider> filterdSides = _sides;
    if (category != null) {
      filterdSides = filterdSides
          .where((element) => element.category == category)
          .toList();
    }
    if (veganOnly) {
      filterdSides = filterdSides.where((element) => element.isVegan).toList();
    }
    if (bestSellersOnly) {
      filterdSides =
          filterdSides.where((element) => element.isBestSeller).toList();
    }
    if (sortByBestSeller) {
      filterdSides.sort((_, second) =>
          second.isBestSeller ? 1 : -1); //hack to sort by bestseller
    }
    return filterdSides;
  }

  dynamic findItemById(String id) {
    if (_pizzas.any((element) => element.id == id)) {
      return _pizzas.singleWhere((element) => element.id == id);
    }
    if (_sides.any((element) => element.id == id)) {
      return _sides.singleWhere((element) => element.id == id);
    }
    return null;
  }
}







/* Sample Schema Of PizzaItemProvider And SidesItemProvider
 PizzaItemProvider(
        id: "123",
        pizzaName: "Veggie Extravaganza",
        pizzaImageUrl: pizzaImageUrls[0],
        description:
            "Indulge in an vegetable heaven created with our unique vegie extravagenza",
        price: {
          PizzaSizes.small: 150,
          PizzaSizes.medium: 300,
          PizzaSizes.large: 500,
        },
        isBestSeller: true,
        isVegan: true,
        isCustomizable: true,
      ),
      

      SidesItemProvider(
        id: "bcd538",
        category: SidesCategory.snacks,
        sidesName: "Vegetable Puffs",
        sidesImageUrl: sidesImageUrls[1],
        sidesDescription: _dummyText,
        price: 60,
        isBestSeller: true,
        isVegan: true,
      ),

  */ 