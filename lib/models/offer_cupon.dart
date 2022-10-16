import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

enum OfferType { offerOnCart, offerOnItem }

abstract class OfferCoupon {
  final String id;
  final String offerCode;
  final String title;
  final String description;
  final int discountPercentage;
  final int maxDiscountAmount;
  final DateTime validTill;
  OfferType get type;
  bool isHeroOffer = false;

  OfferCoupon({
    required this.id,
    required this.offerCode,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.maxDiscountAmount,
    required this.validTill,
    this.isHeroOffer = false,
  });
  factory OfferCoupon.fromMap(
      {required String documentId, required Map<String, dynamic> document}) {
    if (document["offerType"] == "cartOffer") {
      return CartOffer(
        id: documentId,
        offerCode: document["offerCode"],
        title: document["title"],
        description: document["description"],
        discountPercentage: document["discountPercentage"],
        maxDiscountAmount: document["maxDiscountAmount"],
        minValue: document["minValue"],
        validTill: (document["validTill"] as Timestamp).toDate(),
        isHeroOffer: document["isHeroOffer"] ?? false,
      );
    } else {
      return ItemOffer(
        id: documentId,
        offerCode: document["offerCode"],
        title: document["title"],
        description: document["description"],
        discountPercentage: document["discountPercentage"],
        maxDiscountAmount: document["maxDiscountAmount"],
        validTill: (document["validTill"] as Timestamp).toDate(),
        isHeroOffer: document["isHeroOffer"] ?? false,
        applicableItems: (document["applicableItems"] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      );
    }
  }
}

class CartOffer extends OfferCoupon {
  final int minValue;

  CartOffer({
    required super.id,
    required super.offerCode,
    required super.title,
    required super.description,
    required super.discountPercentage,
    required super.maxDiscountAmount,
    required this.minValue,
    required super.validTill,
    super.isHeroOffer = false,
  });

  @override
  OfferType get type => OfferType.offerOnCart;
}

class ItemOffer extends OfferCoupon {
  final List<String> applicableItems;
  ItemOffer({
    required super.id,
    required super.offerCode,
    required super.title,
    required super.description,
    required super.discountPercentage,
    required super.maxDiscountAmount,
    required super.validTill,
    required this.applicableItems,
    super.isHeroOffer = false,
  });

  @override
  OfferType get type => OfferType.offerOnItem;
}
