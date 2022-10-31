import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../maps_display_screen/maps_display_screen.dart';

class AddNewAdressScreen extends StatefulWidget {
  static const routeName = "/add-new-address";
  const AddNewAdressScreen({super.key});

  @override
  State<AddNewAdressScreen> createState() => _AddNewAdressScreenState();
}

class _AddNewAdressScreenState extends State<AddNewAdressScreen> {
  final _formKey = GlobalKey<FormState>();
  Tags? _selectedTag;
  final Map<String, String> _userDetails = {};
  String? _locationName;
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Address"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10.0),
                  label: const Text("Street Name"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                validator: (value) => (value == null || value.length < 3)
                    ? "Please provide valid street name"
                    : null,
                // onSaved: (val) => _userDetails["address"] = val!,
              ),
              const SizedBox(
                height: 25,
              ),
              Card(
                margin: const EdgeInsets.only(left: 0),
                child: ListTile(
                  onTap:
                      _locationName == null ? _whenPickLocationPressed : null,
                  title: _locationName == null
                      ? const Text("Pick your location")
                      : Text(_locationName!),
                  trailing: _locationName == null
                      ? const Icon(Icons.arrow_forward_ios_rounded)
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              _locationName = null;
                              _longitude = null;
                              _latitude = null;
                            });
                          },
                          child: const Text(
                            "Reset",
                            style: TextStyle(color: Colors.red),
                          )),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Text(
                "Tag",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              _TagsRow(
                  selectedTag: _selectedTag,
                  onTagSelected: (selectedTag) {
                    setState(() => _selectedTag = selectedTag);
                  }),
              const SizedBox(
                height: 15.0,
              ),
              if (_selectedTag == Tags.other)
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 10.0),
                    label: const Text("Other Tag Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  validator: (value) => (_selectedTag == Tags.other &&
                          (value == null || value.length < 3))
                      ? "Please provide  tag name of atleast 3 characters"
                      : null,
                  // onSaved: (val) => _userDetails["address"] = val!,
                ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (_locationName == null ||
                            _latitude == null ||
                            _longitude == null) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            _buildSnackBar("Please choose your location"),
                          );
                          return;
                        }
                        if (_selectedTag == null) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            _buildSnackBar("Please choose your tag"),
                          );
                          return;
                        }

                        _formKey.currentState!.save();
                        // setState(() {
                        //   _isLoading = true;
                        // });
                      },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: _isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Register me",
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _whenPickLocationPressed() async {
    //loading indicator when location is being fetched
    showLoadingDialog();
    final isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isGpsEnabled) {
      Navigator.of(context).pop(); //dismiss loading indicator
      return _buildAlertDialog(
        title: "Please enable location",
        description: "You didnt enabled location please turn on location",
      );
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      Navigator.of(context).pop(); //dismiss locading indiactor
      return _buildAlertDialog(
        title: "You denied permision permenently",
        description:
            "Please turn on location permsion permission in your settings app",
        actionBtnText: "Open Settings Page",
        whenActionBtnPressed: () => Geolocator.openAppSettings(),
      );
    }
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        Navigator.of(context).pop();
        return _buildAlertDialog(
          title: "You denied permision permenently",
          description:
              "Please turn on location permsion permission in your settings app",
          actionBtnText: "Open Settings Page",
          whenActionBtnPressed: () => Geolocator.openAppSettings(),
        );
      }
    }
    final userLocation = await Geolocator.getCurrentPosition();
    Navigator.of(context).pop();
    final poppedData = await Navigator.of(context).push(
      MaterialPageRoute<Map<String, dynamic>?>(
        fullscreenDialog: true,
        builder: (context) => MapsDisplayPage(
          initialLatitude: userLocation.latitude,
          initialLongitude: userLocation.longitude,
        ),
      ),
    );
    if (poppedData == null) {
      return _buildAlertDialog(title: "Please confirm location");
    }
    if (poppedData["locationName"] == null) {
      return _buildAlertDialog(title: "Please confirm location");
    }
    setState(() {
      _locationName = poppedData["locationName"];
      _latitude = poppedData["latitude"];
      _longitude = poppedData["longitude"];
    });
  }

  Future<void> _buildAlertDialog({
    required String title,
    String? description,
    String actionBtnText = "Ok",
    void Function()? whenActionBtnPressed,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: description == null ? null : Text(description),
        actions: [
          TextButton(
            onPressed:
                whenActionBtnPressed ?? () => Navigator.of(context).pop(),
            child: Text(actionBtnText),
          )
        ],
      ),
    );
  }

  SnackBar _buildSnackBar(String message) {
    return SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        title: Text("Featching your location"),
        content: CupertinoActivityIndicator(
          radius: 20,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class _TagsRow extends StatelessWidget {
  Tags? selectedTag;
  final void Function(Tags) onTagSelected;
  _TagsRow({required this.selectedTag, required this.onTagSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 15,
      children: [
        InputChip(
          label: const Text("work"),
          avatar: const Icon(Icons.work),
          showCheckmark: false,
          selected: selectedTag == Tags.work,
          onSelected: (_) => onTagSelected(Tags.work),
        ),
        InputChip(
          label: const Text("Family"),
          avatar: const Icon(Icons.family_restroom_outlined),
          showCheckmark: false,
          selected: selectedTag == Tags.family,
          onSelected: (_) => onTagSelected(Tags.family),
        ),
        InputChip(
          label: const Text("Friends"),
          avatar: const Icon(Icons.emoji_people_outlined),
          showCheckmark: false,
          selected: selectedTag == Tags.friends,
          onSelected: (_) => onTagSelected(Tags.friends),
        ),
        InputChip(
          label: const Text("Other"),
          avatar: const Icon(Icons.location_on),
          showCheckmark: false,
          selected: selectedTag == Tags.other,
          onSelected: (_) => onTagSelected(Tags.other),
        ),
      ],
    );
  }
}

enum Tags {
  work("Work"),
  family("Family"),
  friends("Friends"),
  other("Other");

  final String tagName;
  const Tags(this.tagName);
  @override
  String toString() => tagName;
}
