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
