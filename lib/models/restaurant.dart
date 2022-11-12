class Restaurant {
  String resturantId;
  String resturantAddress;
  List<String> itemsAvailable = [];
  Restaurant({
    required this.resturantId,
    required this.resturantAddress,
    required this.itemsAvailable,
  });
  factory Restaurant.fromMap({
    required String resturantId,
    required Map<String, dynamic> data,
  }) {
    List<String> itemsAvailable = [];
    for (var itm in data["itemsAvailable"] as List<dynamic>) {
      if (itm["isAvailable"]) {
        itemsAvailable.add(itm["itemId"]);
      }
    }

    return Restaurant(
      resturantId: resturantId,
      resturantAddress: data["resturantAddress"] ?? "",
      itemsAvailable: itemsAvailable,
    );
  }
}
