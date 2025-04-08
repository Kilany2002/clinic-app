import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng) onLocationSelected;
  final LatLng? initialLocation;

  const LocationPicker({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController mapController;
  LatLng? _selectedLocation;
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(30.0444, 31.2357), // Default to Cairo
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: (controller) => mapController = controller,
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location;
              });
              widget.onLocationSelected(location);
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _selectedLocation != null
                ? 'Selected: ${_selectedLocation!.latitude.toStringAsFixed(4)}, '
                    '${_selectedLocation!.longitude.toStringAsFixed(4)}'
                : 'Tap on the map to select location',
          ),
        ),
      ],
    );
  }
}