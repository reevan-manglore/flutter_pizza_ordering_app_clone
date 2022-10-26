import "package:geoflutterfire/geoflutterfire.dart";
import "package:tuple/tuple.dart" show Tuple2;

class UserAddress {
  String? _tag = "";
  String? _address = "";
  double _longitude = 0.0;
  double _latitude = 0.0;

  UserAddress({
    required longitude,
    required latitude,
    String? tag,
    String? address,
  }) {
    _longitude = longitude;
    _latitude = latitude;
    _tag = tag;
    _address = address;
  }

  factory UserAddress.fromMap(Map<String, dynamic> document) {
    return UserAddress(
      latitude: document["latitude"],
      longitude: document["longitude"],
      address: document["placeName"],
      tag: document["tag"],
    );
  }

  String get address => _address ?? "";
  String get tag => _tag ?? "";

  static String getGeoHashFromLatLang(
      {required double latitude, required double longitude}) {
    return GeoFirePoint(latitude, longitude).hash;
  }

  Tuple2<double, double> get latlong {
    return Tuple2(_latitude, _longitude);
  }

  double get latitude => _latitude;
  double get longitude => _longitude;

  String get hash {
    return GeoFirePoint(_latitude, _longitude).hash;
  }

  GeoFirePoint get firePoint {
    return GeoFirePoint(_latitude, _longitude);
  }
}
