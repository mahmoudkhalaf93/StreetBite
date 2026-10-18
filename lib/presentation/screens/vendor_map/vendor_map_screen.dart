import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/app_colors.dart';

class VendorMapScreen extends StatefulWidget {
  const VendorMapScreen({super.key});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.0444, 31.2357), // Cairo Center
    zoom: 11,
  );

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('vendor_1'),
      position: LatLng(30.0444, 31.2357), // Downtown Cairo
      infoWindow: InfoWindow(
        title: 'StreetBite Downtown Grill',
        snippet: 'Cuisine: Egyptian BBQ • ⭐ 4.9',
      ),
    ),
    const Marker(
      markerId: MarkerId('vendor_2'),
      position: LatLng(30.0561, 31.3301), // Heliopolis
      infoWindow: InfoWindow(
        title: 'El-Basha Koshary & Tacos',
        snippet: 'Cuisine: Mexican & Egyptian • ⭐ 4.8',
      ),
    ),
    const Marker(
      markerId: MarkerId('vendor_3'),
      position: LatLng(29.9602, 31.2569), // Maadi
      infoWindow: InfoWindow(
        title: 'Nile Burger & Wings',
        snippet: 'Cuisine: Burgers • ⭐ 4.7',
      ),
    ),
    const Marker(
      markerId: MarkerId('vendor_4'),
      position: LatLng(30.0131, 31.2089), // Giza
      infoWindow: InfoWindow(
        title: 'Pyramids Street Shawarma',
        snippet: 'Cuisine: Middle Eastern • ⭐ 4.9',
      ),
    ),
    const Marker(
      markerId: MarkerId('vendor_5'),
      position: LatLng(31.2001, 29.9187), // Alexandria
      infoWindow: InfoWindow(
        title: 'Alexandria Seafood Bites',
        snippet: 'Cuisine: Seafood & Fish • ⭐ 4.8',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nearby Vendors',
          style: TextStyle(fontFamily: 'SF Pro', fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onMapCreated: (controller) {},
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
