import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng, String) onLocationSelected;

  const LocationPickerScreen({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController mapController;
  LatLng? _selectedLocation;
  String _address = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    if (_selectedLocation != null) {
      _getAddressFromLatLng(_selectedLocation!);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    final location = loc.Location();
    try {
      final currentLocation = await location.getLocation();
      final latLng = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));
      setState(() => _selectedLocation = latLng);
      await _getAddressFromLatLng(latLng);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final places = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (places.isNotEmpty) {
        final place = places.first;
        setState(() {
          _address = [
            place.street,
            place.locality,
            place.administrativeArea,
            place.country
          ].where((part) => part?.isNotEmpty ?? false).join(', ');
        });
      }
    } catch (e) {
      setState(() => _address = 'Unknown location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _selectedLocation != null
                ? () {
                    widget.onLocationSelected(_selectedLocation!, _address);
                    Navigator.pop(context);
                  }
                : null,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? const LatLng(30.0444, 31.2357),
              zoom: 12,
            ),
            onMapCreated: (controller) => mapController = controller,
            onTap: (LatLng location) async {
              setState(() => _selectedLocation = location);
              await _getAddressFromLatLng(location);
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Location',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _address.isNotEmpty
                          ? _address
                          : 'Tap on the map to select location',
                    ),
                    if (_selectedLocation != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, '
                        'Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}