import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';
import "../../providers/user_account_provider.dart";

import '../maps_display_screen/maps_display_screen.dart';

import '../home_page/home_page.dart';

class UserRegistrationScreen extends StatefulWidget {
  static const String routeName = "/user-registration-screen";
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _userDetails = {};
  String? _locationName;
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userAccount = Provider.of<UserAccountProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80.0,
              ),
              RichText(
                text: const TextSpan(
                    text: "First Of All Lets",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                    children: [
                      TextSpan(text: " "),
                      TextSpan(
                        text: "Register You",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10.0),
                  label: const Text("Name"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                validator: (value) => (value == null || value.length < 3)
                    ? "Please provide name of minimum 3 chars"
                    : null,
                onSaved: (val) => _userDetails["name"] = val!,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10.0),
                  label: const Text("Phone"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                validator: (value) => (value == null || value.length < 10)
                    ? "Please provide valid 10 digit phone number "
                    : null,
                onSaved: (val) => _userDetails["phoneNumber"] = val!,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Home Address",
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Card(
                      margin: const EdgeInsets.only(left: 0),
                      child: ListTile(
                        onTap: _locationName == null
                            ? _whenPickLocationPressed
                            : null,
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
                      height: 15.0,
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
                      onSaved: (val) => _userDetails["address"] = val!,
                    ),
                  ],
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
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
                        _formKey.currentState!.save();
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          await userAccount.createNewUser(
                            name: _userDetails["name"]!,
                            phoneNumber: _userDetails["phoneNumber"]!,
                            address: _userDetails["address"]!,
                            latitude: _latitude!,
                            longitude: _longitude!,
                            tag: "Home",
                          );
                          Navigator.of(context)
                              .pushReplacementNamed(HomePage.routeName);
                        } on FirebaseException catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            _buildSnackBar(e.message ?? "Some error occured"),
                          );
                        } catch (_) {
                          _buildSnackBar("Some error occured");
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                child: _isLoading
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
