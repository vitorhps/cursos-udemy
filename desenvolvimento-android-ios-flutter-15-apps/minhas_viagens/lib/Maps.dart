import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {

  String tripId;

  Maps({ this.tripId });

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {

  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(-22.226464, -54.793684),
    zoom: 18,
  );
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Firestore _db = Firestore.instance;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _addMarker(LatLng latLng) async {
    List<Placemark> addressList = await Geolocator()
      .placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (addressList == null || addressList.length == 0) {
      return;
    }

    Placemark address = addressList[0];
    String street = address.thoroughfare;

    Marker marker = Marker(
      markerId: MarkerId("marker-${latLng.latitude}-${latLng.longitude}"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
      ),
    );

    setState(() {
      _markers.add(marker);
    });

    Map<String, dynamic> trip = Map();
    trip["title"] = street;
    trip["latitude"] = latLng.latitude;
    trip["longitude"] = latLng.longitude;

    _db.collection("travels")
      .add(trip);
  }

  _moveCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(_cameraPosition),
    );
  }

  _addLocationListener() {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 18,
      );
      setState(() {
        _cameraPosition = cameraPosition;
      });
      _moveCamera();
    });
  }

  _retriveTrip(String tripId) async {
    if (tripId != null) {
      DocumentSnapshot documentSnapshot = await _db
        .collection("travels")
        .document(tripId)
        .get();

      var data = documentSnapshot.data;

      LatLng latLng = LatLng(
        data["latitude"],
        data["longitude"],
      );

      Marker marker = Marker(
        markerId: MarkerId(tripId),
        position: latLng,
        infoWindow: InfoWindow(
          title: data["title"],
        ),
      );

      setState(() {
        _markers.add(marker);
        _cameraPosition = CameraPosition(
          target: latLng,
          zoom: 18,
        );
      });

      _moveCamera();

    } else {
      _addLocationListener();
    }
  }

  @override
  void initState() {
    super.initState();

    _retriveTrip(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa"),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _cameraPosition,
          onMapCreated: _onMapCreated,
          onLongPress: _addMarker,
          markers: _markers,
        ),
      ),
    );
  }
}
