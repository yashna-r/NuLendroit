import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocation extends StatefulWidget {

  final String location, latitude, longitude;
  MapLocation({this.location, this.latitude, this.longitude});

  @override
  _MapLocationState createState() => _MapLocationState();
}


class _MapLocationState extends State<MapLocation> {

  String address;
  final Map<String, Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _mauritiusMap = CameraPosition(
    //Coordinates of Mauritius
    target: LatLng(-20.244959, 57.561768),
    zoom: 10.0,
  );


  @override
  Widget build(BuildContext context) {

    double latitude = double.parse(widget.latitude);
    double longitude = double.parse(widget.longitude);
    print('Coordinates are: $latitude , $longitude');

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(latitude, longitude),
//        infoWindow: InfoWindow(title: 'Event is here'),
      );
      _markers["Current Location"] = marker;
    });

    return new Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),

      body: Stack(
          children:<Widget>[
            GoogleMap(
              initialCameraPosition: _mauritiusMap,
              onMapCreated: _onMapCreated, //onMapCreated,
              markers: _markers.values.toSet(),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical:10.0),
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical:10.0),
              color: Colors.white70,
              child: SizedBox(
                width: 350.0,
                  child: Text(widget.location,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
              ),
            )

          ]
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _moveToPosition(latitude, longitude);
        },
//        tooltip: 'Get Location',
        child: Icon(Icons.flag),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  void _moveToPosition(double latitude, double longitude) async {
    final GoogleMapController mapController = await _controller.future;
    if (mapController == null) return;
    print('moving to position $latitude, $longitude');
    mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 15.0,
          ),
        )
    );
  }
}