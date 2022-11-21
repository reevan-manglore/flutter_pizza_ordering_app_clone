import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocode/geocode.dart';

class MapsDisplayPage extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  const MapsDisplayPage({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
  });

  @override
  State<MapsDisplayPage> createState() => _MapsDisplayPageState();
}

class _MapsDisplayPageState extends State<MapsDisplayPage> {
  late final MapController _mapController;

  @override
  void initState() {
    _mapController = MapController(
      initPosition: GeoPoint(
        latitude: widget.initialLatitude,
        longitude: widget.initialLongitude,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isLocationConfirmLocationBtnPressed = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose your location"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            // ignore: prefer_const_constructors
            Expanded(
              child: Container(
                color: Colors.blue.shade100,
                child: Center(
                  child: OSMFlutter(
                    isPicker: true,
                    controller: _mapController,
                    initZoom: 14,
                    minZoomLevel: 8,
                    stepZoom: 1.0,
                    markerOption: MarkerOption(
                      advancedPickerMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: ElevatedButton(
                onPressed: _isLocationConfirmLocationBtnPressed == true
                    ? null
                    : () async {
                        setState(
                          () => _isLocationConfirmLocationBtnPressed = true,
                        );
                        final pickedLocation =
                            await _mapController.selectAdvancedPositionPicker();
                        final locationName = await GeoCode().reverseGeocoding(
                          latitude: pickedLocation.latitude,
                          longitude: pickedLocation.longitude,
                        );
                        Map<String, dynamic> data = {
                          "locationName": locationName.streetAddress,
                          "latitude": pickedLocation.latitude,
                          "longitude": pickedLocation.longitude,
                        };
                        Navigator.pop(context, data);
                      },
                child: _isLocationConfirmLocationBtnPressed == true
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Confirm Location",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  minimumSize: const Size.fromHeight(32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
