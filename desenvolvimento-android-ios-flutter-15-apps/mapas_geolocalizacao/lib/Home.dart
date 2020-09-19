import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _completer = Completer();
  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(-22.2256626, -54.7927799),
    zoom: 16,
  );
  Set<Marker> _markers = {};
  Set<Polygon> _polygons= {};
  Set<Polyline> _polylines = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _completer.complete(googleMapController);
  }

  _moveCamera() async {
     GoogleMapController googleMapController= await _completer.future;
     googleMapController.animateCamera(
       CameraUpdate.newCameraPosition(_cameraPosition),
     );
  }

  _loadMarkers() {

    Set<Marker> localMarkers = {};

    Marker marker01 = Marker(
      markerId: MarkerId("mark01"),
      position: LatLng(-22.2256626, -54.7927799),
    );

    Marker marker02 = Marker(
      markerId: MarkerId("mark02"),
      position: LatLng(-22.2252332, -54.7912048),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
    );

    Marker marker03 = Marker(
      markerId: MarkerId("mark03"),
      position: LatLng(-22.2258508, -54.791543),
      rotation: 45,
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Extra"),
            );
          }
        );
      }
    );
    
    localMarkers.add(marker01);
    localMarkers.add(marker02);
    localMarkers.add(marker03);

    setState(() {
      _markers = localMarkers;
    });
  }

  _loadPolygons() {
    Set<Polygon> polygonList = {};

    Polygon polygon01 = Polygon(
      polygonId: PolygonId("polygon01"),
      fillColor: Colors.green,
      strokeColor: Colors.red,
      strokeWidth: 20,
      points: [
        LatLng(-22.2256626, -54.7927799),
        LatLng(-22.2252332, -54.7912048),
        LatLng(-22.2258508, -54.791543),
      ],
      zIndex: 1,
      consumeTapEvents: true,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Área clicada"),
            );
          }
        );
      }
    );

    Polygon polygon02 = Polygon(
      polygonId: PolygonId("polygon02"),
      fillColor: Colors.purple,
      strokeColor: Colors.red,
      strokeWidth: 20,
      points: [
        LatLng(-22.2256626, -54.7927799),
        LatLng(-22.2254332, -54.7922048),
        LatLng(-22.2256508, -54.791843),
        LatLng(-22.2259508, -54.793543),
      ],
      zIndex: 0,
    );

    polygonList.add(polygon01);
    polygonList.add(polygon02);

    setState(() {
      _polygons = polygonList;
    });
  }

  _loadPolylines() {
    Set<Polyline> polylineList = {};

    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.red,
      width: 20,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      points: [
        LatLng(-22.2256626, -54.7927799),
        LatLng(-22.2252332, -54.7912048),
        LatLng(-22.2258508, -54.791543),
      ],
      consumeTapEvents: true,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Área clicada"),
            );
          }
        );
      }
    );

    polylineList.add(polyline);

    setState(() {
      _polylines = polylineList;
    });
  }

  _retriveUserLocation() async {
    Position userPosition = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _cameraPosition = CameraPosition(
        target: LatLng(userPosition.latitude, userPosition.longitude),
        zoom: 17,
      );
    });

    _moveCamera();
  }

  _addListenerLocation() {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      setState(() {
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17,
        );
      });

      _moveCamera();
    });
  }

  _retriveAddress() async {
    List<Placemark> addressList = await Geolocator()
      .placemarkFromAddress("Av. Marcelino Píres, 3600");

    if (addressList != null && addressList.length > 0) {
      Placemark address = addressList[0];

      print("AdministrativeArea: " + address.administrativeArea);
      print("SubAdministrativeArea: " + address.subAdministrativeArea);
      print("Locality: " + address.locality);
      print("SubLocality: " + address.subLocality);
      print("Thoroughfare: " + address.thoroughfare);
      print("SubThoroughfare: " + address.subThoroughfare);
      print("PostalCode: " + address.postalCode);
      print("Country: " + address.country);
      print("IsoCountryCode: " + address.isoCountryCode);
      print("Position: " + address.position.toString());
    }
  }

  _retriveCoordinates() async {
    List<Placemark> addressList = await Geolocator()
      .placemarkFromCoordinates(-22.2256626, -54.7927799);

    if (addressList != null && addressList.length > 0) {
      Placemark address = addressList[0];

      print("AdministrativeArea: " + address.administrativeArea);
      print("SubAdministrativeArea: " + address.subAdministrativeArea);
      print("Locality: " + address.locality);
      print("SubLocality: " + address.subLocality);
      print("Thoroughfare: " + address.thoroughfare);
      print("SubThoroughfare: " + address.subThoroughfare);
      print("PostalCode: " + address.postalCode);
      print("Country: " + address.country);
      print("IsoCountryCode: " + address.isoCountryCode);
      print("Position: " + address.position.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    // _loadMarkers();
    // _loadPolygons();
    // _loadPolylines();

    // _retriveUserLocation();
    // _addListenerLocation();

    _retriveAddress();
    _retriveCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapas e Geolocalização"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _moveCamera,
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          // mapType: MapType.none,
          // mapType: MapType.hybrid,
          // mapType: MapType.satellite,
          // mapType: MapType.terrain,
          initialCameraPosition: _cameraPosition,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: _markers,
          polygons: _polygons,
          polylines: _polylines,
        ),
      ),
    );
  }
}
