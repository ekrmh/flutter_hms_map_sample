import 'package:flutter/material.dart';
import 'package:huawei_map/components/cameraPosition.dart';
import 'package:huawei_map/components/latLng.dart';
import 'package:huawei_map/constants/mapType.dart';
import 'package:huawei_map/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};

  HuaweiMapController _mapController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          HuaweiMap(
              // When the map created this function calls.
              onMapCreated: (_mapController) {
                this._mapController = _mapController;
                _drawPolyine();
                _drawCircles();
              },
              mapToolbarEnabled: true,

              // Map clicked
              onClick: (location) {
                print("Map clicked: ${location.lat} - ${location.lng}");
                _moveCamera(location.lat, location.lng);
              },

              // Map long clicked
              onLongPress: (location) {
                print("Map long clicked: ${location.lat} - ${location.lng}");
                _addMarker(location);
                _drawPolygon();
              },

              // Markers
              markers: _markers,

              // Polygons
              polygons: _polygons,

              // Polylines
              polylines: _polylines,

              // Circles
              circles: _circles,

              // Restrict camera movement
              // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
              //     southwest: LatLng(0, 0),
              //     northeast: LatLng(0, 180))),

              // Initial Camera position
              initialCameraPosition: CameraPosition(
                target: const LatLng(41.012959, 28.997438),
                zoom: 0,
              ),

              // MapType.none: Displaying map without any data
              // MapType.normal: Standart Map
              mapType: MapType.normal,
              tiltGesturesEnabled: false,
              // Allow rotate
              rotateGesturesEnabled: true,
              // Allow Scroll on map
              scrollGesturesEnabled: true,

              // Display zoom in and out buttons
              zoomControlsEnabled: true,

              // Zoom with pinch move
              zoomGesturesEnabled: true,

              // Setting min max zoom
              minMaxZoomPreference: MinMaxZoomPreference(0, 10),

              // Display compass when user rotate the map
              compassEnabled: true,
              // Allow buildings
              buildingsEnabled: true,

              // Display my location button and location on the map
              myLocationButtonEnabled: true,
              myLocationEnabled: true,

              // Allow display traffic statics
              trafficEnabled: true,

              // Camera actions
              onCameraMove: (CameraPosition pos) => {
                    print("Camera moved: ${pos.target.lat} : ${pos.target.lng}")
                  },
              onCameraIdle: () {
                print("Camera idle");
              },
              onCameraMoveStarted: () {
                print("Camera move started");
              }),
        ],
      ),
    );
  }

  void _moveCamera(double lat, double long,
      {zoom = 0.0, bearing = 0.0, tilt = 0.0}) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          bearing: bearing, target: LatLng(lat, long), zoom: zoom, tilt: tilt),
    ));
  }

  void _addMarker(LatLng location) {
    String markerId = "${location.lat}-${location.lng}";
    Marker marker = new Marker(
      markerId: MarkerId(markerId),
      position: location,
      infoWindow: InfoWindow(
        title: 'Title',
        snippet: 'Desc: $markerId',
      ),
      clickable: true,
      onClick: () {
        print("Marker clicked: $markerId");
      },
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _drawPolygon() {
    List<LatLng> dots = [];
    _markers.forEach((element) => dots.add(element.position));

    Polygon polygon = new Polygon(
        polygonId: PolygonId("MyPolygon"),
        points: dots,
        fillColor: Colors.green[500],
        strokeColor: Colors.green[900],
        strokeWidth: 5,
        zIndex: 2,
        clickable: true,
        onClick: () {
          print("Polygon clicked");
        });
    setState(() {
      _polygons.add(polygon);
    });
  }

  void _drawPolyine() {
    List<LatLng> dots = [
      new LatLng(41.06071, 28.98772),
      new LatLng(37.918918340362126, 28.841235177965157),
      new LatLng(38.333751978957025, 41.49748517796515),
      new LatLng(40.50613755298146, 37.10295392796515),
      new LatLng(43.76381655600656, 32.00529767796515),
      new LatLng(43.76381655600656, 37.98186017796515),
      new LatLng(41.171068847183165, 46.06779767796515),
      new LatLng(35.66696096190562, 45.36467267796515),
      new LatLng(33.934999616332846, 32.00529767796515),
      new LatLng(39.156327381163464, 20.052172677965157)
    ];

    Polyline polyline = new Polyline(
        polylineId: PolylineId("MyPolyline"),
        points: dots,
        color: Colors.red[500],
        zIndex: 2,
        clickable: true,
        onClick: () {
          print("Polyline clicked");
        });

    setState(() {
      _polylines.add(polyline);
    });
  }

  void _drawCircles() {
    setState(() {
      _circles.add(Circle(
          circleId: CircleId('MyCircle'),
          center: LatLng(0, 0),
          radius: 3000,
          visible: true,
          fillColor: Color.fromARGB(100, 100, 100, 0),
          strokeColor: Colors.blue,
          strokeWidth: 20,
          zIndex: 2,
          clickable: true,
          onClick: () {
            print("Circle clicked");
          }));
    });
  }
}
