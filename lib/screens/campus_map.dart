
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = LatLng(29.9866381, 31.4414218);
  final LatLngBounds _mapBounds = LatLngBounds(
    southwest: const LatLng(29.9600, 30.0000),
    northeast: const LatLng(30.0800, 31.5000),
  );
  LatLng sourceLocation = _center;
  LatLng destination = const LatLng(30.001270, 31.432470);
  Set<Marker> markers = {};
  List<LatLng> polyLineCoordinates = [];
  loc.LocationData? currentLocation;
  final loc.Location location = loc.Location();
  String _eta = 'Fetching ETA...';
  List<String> _instructions = [];
  bool _showInstructions = false; // Track whether instructions are visible

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      final bool serviceRequested = await location.requestService();
      if (!serviceRequested) return;
    }

    final loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      final loc.PermissionStatus permissionRequested = await location.requestPermission();
      if (permissionRequested != loc.PermissionStatus.granted) return;
    }

    final loc.LocationData initialLocation = await location.getLocation();
    setState(() {
      currentLocation = initialLocation;
    });

    location.onLocationChanged.listen((loc.LocationData locData) {
      setState(() {
        currentLocation = locData;
      });
    });
  }

  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: dotenv.env['googleApiKey'],
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.walking,
      ),
    );

    if (result.status == 'OK' && result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        polyLineCoordinates = polylineCoordinates;
      });
    } else {
      print('Error retrieving polyline: ${result.errorMessage}');
    }
  }

  void _setLocation(LatLng position, bool isSource) {
  setState(() {
    // Remove the existing marker for the source or destination before adding the new one
    if (isSource) {
      // Remove the old source marker if it exists
      markers.removeWhere((marker) => marker.markerId == const MarkerId("source"));
      sourceLocation = position;
      markers.add(Marker(
        markerId: const MarkerId("source"),
        position: sourceLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    } else {
      // Remove the old destination marker if it exists
      markers.removeWhere((marker) => marker.markerId == const MarkerId("destination"));
      destination = position;
      markers.add(Marker(
        markerId: const MarkerId("destination"),
        position: destination,
      ));
    }

    // Update the polyline and fetch new ETA and instructions
    getPolyPoints();
    _fetchETAAndInstructions();
  });
}


  bool flag = true;
  
  void _handleMapTap(LatLng tappedPoint) {
    _setLocation(tappedPoint, flag);
    flag = !flag;
  }

  Future<List<String>> _getSuggestions(String query) async {
    List<String> suggestions = ["Current Location"];
    if (query.isEmpty) return suggestions;

    try {
      List<geo.Location> locations = await geo.locationFromAddress(query);
      suggestions.addAll(locations.map((loc) => "${loc.latitude}, ${loc.longitude}").toList());
    } catch (e) {
      print("Error retrieving suggestions: $e");
    }

    return suggestions;
  }

  Future<void> _fetchETAAndInstructions() async {
    try {
      final result = await _getETAAndInstructions(
        sourceLocation,
        destination,
        dotenv.env['googleApiKey']!,
        'walking',
      );
      setState(() {
        _eta = result['eta'];
        _instructions = result['instructions'];
      });
    } catch (e) {
      setState(() {
        _eta = 'Error fetching ETA';
      });
    }
  }

  Future<Map<String, dynamic>> _getETAAndInstructions(
      LatLng origin, LatLng destination, String apiKey, String mode) async {
    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=$mode'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        final duration = data['routes'][0]['legs'][0]['duration']['text'];
        final List<Map<String, dynamic>> steps =
            (data['routes'][0]['legs'][0]['steps'] as List<dynamic>)
                .cast<Map<String, dynamic>>();

        List<String> instructions = steps.map<String>((step) {
          return (step['html_instructions'] as String)
              .replaceAll(RegExp(r'<[^>]*>'), '');
        }).toList();

        return {
          'eta': duration,
          'instructions': instructions,
        };
      } else {
        return {
          'eta': 'Error: ${data['status']}',
          'instructions': [],
        };
      }
    } else {
      throw Exception('Failed to load ETA and instructions');
    }
  }

  void _toggleInstructionsVisibility() {
    setState(() {
      _showInstructions = !_showInstructions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus Map"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ETA: $_eta',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _toggleInstructionsVisibility,
                  child: Text(_showInstructions
                      ? "Hide Instructions"
                      : "Show Instructions"),
                ),
              ],
            ),
          ),
          if (_showInstructions)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _instructions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.directions_walk),
                    title: Text(_instructions[index]),
                  );
                },
              ),
            ),
          Expanded(
            child: currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: sourceLocation,
                      zoom: 16.0,
                    ),
                    indoorViewEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.hybrid,
                    cameraTargetBounds: CameraTargetBounds(_mapBounds),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: polyLineCoordinates,
                        color: Colors.blue,
                        width: 6,
                      ),
                    },
                    markers: markers,
                    onTap: _handleMapTap,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
