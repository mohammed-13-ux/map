import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/pharmacy_model.dart';

class MapViewModel extends ChangeNotifier {
  final MapController mapController = MapController();
  double currentZoom = 13.0;
  LatLng? userLocation;

  List<Pharmacy> pharmacies = [
    Pharmacy(name: "Pharmacie Centrale", prenom: "Ahmed", email: "ahmed.pharmacie@gmail.com", lat: 34.8828, lng: -1.3162),
    Pharmacy(name: "Pharmacie El Nour", prenom: "Sofia", email: "sofia.elnour@email.com", lat: 34.8850, lng: -1.3185),
    Pharmacy(name: "Pharmacie Ibn Sina", prenom: "Karim", email: "karim.ibnsina@email.com", lat: 34.8901, lng: -1.3200),
  ];

  MapViewModel() {
    _getUserLocation();
  }

  // 🔹 Obtenir et suivre la position de l'utilisateur
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    userLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }

  // 🔹 Centrer la carte sur l'utilisateur
  void centerOnUser() {
    if (userLocation != null) {
      mapController.move(userLocation!, currentZoom);
    }
  }

  void zoomIn() {
    currentZoom += 1;
    mapController.move(mapController.camera.center, currentZoom);
    notifyListeners();
  }

  void zoomOut() {
    currentZoom -= 1;
    mapController.move(mapController.camera.center, currentZoom);
    notifyListeners();
  }
}
