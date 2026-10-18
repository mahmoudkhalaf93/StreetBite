import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_colors.dart';

class VendorMapScreen extends StatefulWidget {
  const VendorMapScreen({super.key});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  BitmapDescriptor? _customIcon;
  bool _isLoadingLocation = true;

  LatLng _userPosition = const LatLng(30.0444, 31.2357); // Fallback Cairo

  @override
  void initState() {
    super.initState();
    _loadCustomIconAndLocation();
  }

  Future<void> _loadCustomIconAndLocation() async {
    try {
      // Load custom App Logo marker
      _customIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/icons/appicon.png',
      );
    } catch (_) {
      _customIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }

    await _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        _userPosition = LatLng(position.latitude, position.longitude);
      }
    } catch (_) {
      // Keep fallback position if error occurs
    }

    _generateNearbyVendors();

    if (mounted) {
      setState(() => _isLoadingLocation = false);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_userPosition, 14.5),
      );
    }
  }

  void _showVendorDetailsSheet(Map<String, dynamic> vendor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/icons/appicon.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor['title'] as String,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vendor['cuisine'] as String,
                        style: const TextStyle(
                          fontFamily: 'SF Compact',
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${vendor['rating']}',
                        style: const TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.restaurant_menu_rounded),
                label: const Text(
                  'Explore Menu',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context); // Return to home/menu
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateNearbyVendors() {
    final lat = _userPosition.latitude;
    final lng = _userPosition.longitude;

    final vendors = [
      {
        'id': 'v1',
        'title': 'StreetBite Downtown Grill',
        'cuisine': 'Egyptian BBQ & Sandwiches',
        'rating': 4.9,
        'offsetLat': 0.003,
        'offsetLng': 0.002,
      },
      {
        'id': 'v2',
        'title': 'El-Basha Koshary & Tacos',
        'cuisine': 'Mexican & Egyptian Fusion',
        'rating': 4.8,
        'offsetLat': -0.004,
        'offsetLng': 0.003,
      },
      {
        'id': 'v3',
        'title': 'Nile Burger & Wings',
        'cuisine': 'Gourmet Burgers & Fries',
        'rating': 4.7,
        'offsetLat': 0.002,
        'offsetLng': -0.004,
      },
      {
        'id': 'v4',
        'title': 'Pyramids Street Shawarma',
        'cuisine': 'Middle Eastern Shawarma',
        'rating': 4.9,
        'offsetLat': -0.003,
        'offsetLng': -0.003,
      },
      {
        'id': 'v5',
        'title': 'Alexandria Seafood Bites',
        'cuisine': 'Seafood & Fish Delights',
        'rating': 4.8,
        'offsetLat': 0.005,
        'offsetLng': 0.004,
      },
    ];

    final iconToUse = _customIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

    _markers = vendors.map((v) {
      final pos = LatLng(lat + (v['offsetLat'] as double), lng + (v['offsetLng'] as double));
      return Marker(
        markerId: MarkerId(v['id'] as String),
        position: pos,
        icon: iconToUse,
        infoWindow: InfoWindow(
          title: v['title'] as String,
          snippet: '⭐ ${v['rating']} • ${v['cuisine']}',
        ),
        onTap: () {
          _showVendorDetailsSheet(v);
        },
      );
    }).toSet();
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: _getUserLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _userPosition, zoom: 14),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          if (_isLoadingLocation)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
