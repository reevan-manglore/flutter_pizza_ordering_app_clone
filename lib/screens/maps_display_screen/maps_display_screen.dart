import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    "your currently residing in latitude = ${widget.initialLatitude} , longitude = ${widget.initialLongitude}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> data = {
                    "locationName": "In Middle Of Nowhere",
                    "latitude": widget.initialLatitude,
                    "longitude": widget.initialLongitude,
                  };
                  Navigator.pop(context, data);
                },
                child: Text(
                  "Confirm Location",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
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
}
