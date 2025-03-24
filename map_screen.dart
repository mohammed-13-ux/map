import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../viewmodels/map_view_model.dart';
import '../models/pharmacy_model.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Carte de Tlemcen - Pharmacies")),
      body: Stack(
        children: [
          Consumer<MapViewModel>(
            builder: (context, viewModel, child) {
              return FlutterMap(
                mapController: viewModel.mapController,
                options: MapOptions(
                  initialCenter: LatLng(34.8828, -1.3162),
                  initialZoom: viewModel.currentZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      ...viewModel.pharmacies.map((pharmacy) {
                        return Marker(
                          width: 40.0,
                          height: 40.0,
                          point: LatLng(pharmacy.lat, pharmacy.lng),
                          child: GestureDetector(
                            onTap: () => _showInfoWindow(context, pharmacy),
                            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                          ),
                        );
                      }).toList(),
                      if (viewModel.userLocation != null)
                        Marker(
                          width: 50.0,
                          height: 50.0,
                          point: viewModel.userLocation!,
                          child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 50),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: () => context.read<MapViewModel>().zoomIn(),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: () => context.read<MapViewModel>().zoomOut(),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "userLocation",
                  onPressed: () => context.read<MapViewModel>().centerOnUser(),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoWindow(BuildContext context, Pharmacy pharmacy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
              const SizedBox(height: 10),
              const Text("Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _infoField("Nom", pharmacy.name),
              const SizedBox(height: 10),
              _infoField("Prénom", pharmacy.prenom),
              const SizedBox(height: 10),
              _infoField("Email", pharmacy.email),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
