import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ddnbilaspur_mob/app-const/app_constants.dart';
import 'package:ddnbilaspur_mob/model/property.model.dart';
import 'package:ddnbilaspur_mob/screens/property_details.dart';
import 'package:ddnbilaspur_mob/service/http_request.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../ddn_app.dart';
import '../model/account.model.dart';
import '../model/user_info.model.dart';
import '../widgets/drawer_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
  final String appVersion = '1.0.0'; // Replace with your app version
}

class _HomeState extends State<Home> {
  late GoogleMapController _mapController;
  late double longitude;
  late double latitude;
  late double altitude;
  late List<Property> _properties = [];
  bool _latLongAltSet = false;
  bool _satelliteView = false;

  Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();
    _getLatLongAlt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
          icon: Icons.menu,
          activeIcon: Icons.close,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.question_answer_outlined),
              label: 'Survey',
              onTap: () {
                DDNApp.navigatorKey.currentState?.pushNamed('/filter-property');
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.add_chart_outlined),
              label: 'Add Property',
              onTap: () {
                DDNApp.navigatorKey.currentState?.pushNamed('/add-property');
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.dashboard_customize_outlined),
              label: 'Dashboard',
              onTap: () {
                DDNApp.navigatorKey.currentState?.pushNamed('/dashboard');
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.report_gmailerrorred_outlined),
              label: 'Reports',
              onTap: () {
                DDNApp.navigatorKey.currentState?.pushNamed('/reports');
              },
            ),
          ]),
      backgroundColor: Colors.white,
      appBar: AppBar(
          //leading: Image.asset('assets/icons/favicon.ico'),
          title: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getAccount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final account = snapshot.data as Account;
                    return Center(
                      child: Text('${account.firstName} ${account.lastName}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    );
                  }
                }
                return const SizedBox(
                    height: 10.0,
                    width: 10.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.lime,
                    ));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 7),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final userInfo = snapshot.data as UserInfo;
                    List<String?> wards = [];
                    for (var i = 0; i < userInfo.wards!.length; ++i) {
                      var ward = userInfo.wards![i];
                      wards.add(ward.wardNumber);
                    }
                    return Center(
                      child: Text('Wards: $wards',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15)),
                    );
                  }
                }
                return const SizedBox(
                    height: 10.0,
                    width: 10.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.lime,
                    ));
              },
            )
          ],
        ),
      )),
      drawer: const DrawerWidget(appVersion: '1.0'),
      body: _latLongAltSet
          ? Stack(
              children: [
                GoogleMap(
                  /*minMaxZoomPreference: const MinMaxZoomPreference(15, 22),*/
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  rotateGesturesEnabled: false,
                  mapToolbarEnabled: true,
                  mapType: _satelliteView ? MapType.satellite : MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  onCameraIdle: () async {
                    LatLngBounds llb = await _mapController.getVisibleRegion();
                    if (DDNApp.userInfo == null) {
                      Fluttertoast.showToast(
                          msg:
                              "User unavailable, to see the property markers move map when available!",
                          fontSize: 10,
                          toastLength: Toast.LENGTH_LONG);
                      return;
                    }
                    var url = "${AppConstant.baseUrl}/api/properties?"
                        "longitude.greaterThanOrEqual=${llb.southwest.longitude}"
                        "&longitude.lessThanOrEqual=${llb.northeast.longitude}"
                        "&latitude.greaterThanOrEqual=${llb.southwest.latitude}"
                        "&latitude.lessThanOrEqual=${llb.northeast.latitude}&page=0&size=200";
                    final wards = DDNApp.userInfo!.wards;
                    for (var i = 0; i < wards!.length; ++i) {
                      var ward = wards[i];
                      url += "&wardId.in=${ward.id}";
                    }
                    final propertyResponse = await authorizedGetRequest(
                        Uri.parse(url), {'Content-Type': 'application/json'});
                    final propertyList = jsonDecode(propertyResponse.body);
                    markers = {};
                    final Uint8List markerIcon = await getBytesFromAsset(
                        'assets/icons/green_pin_64px.ico', 148);
                    for (var i = 0; i < propertyList.length; ++i) {
                      Property property = Property.fromJson(propertyList[i]);
                      Marker marker = Marker(
                          markerId: MarkerId('${property.id!}'),
                          draggable: false,
                          position:
                              LatLng(property.latitude!, property.longitude!),
                          infoWindow: InfoWindow(
                              title: property.propertyUid,
                              snippet: "DDN: ${property.ddnString}\nTest",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PropertyDetailsView(
                                                property: property)));
                              }));
                      if (property.propertyStatus != null &&
                          property.propertyStatus!.contains('INSTALLED')) {
                        marker = Marker(
                            icon: BitmapDescriptor.fromBytes(markerIcon),
                            markerId: MarkerId('${property.id!}'),
                            draggable: false,
                            position:
                                LatLng(property.latitude!, property.longitude!),
                            infoWindow: InfoWindow(
                                title: property.propertyUid,
                                snippet: "DDN: ${property.ddnString}\nTest",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PropertyDetailsView(
                                                  property: property)));
                                }));
                      }
                      markers.add(marker);
                    }
                    setState(() {
                      markers = markers;
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude!, longitude!),
                    zoom: 17,
                  ),
                  markers: markers,
                ),
                IconButton(
                  onPressed: () => setState(() {
                    _satelliteView = !_satelliteView;
                  }),
                  icon: const Icon(Icons.satellite_alt_sharp),
                  color: _satelliteView ? Colors.amberAccent : Colors.blueGrey,
                )
              ],
            )
          : Center(
              child: Column(
                children: const [
                  SizedBox(height: 200),
                  Text("Fetching Current Location"),
                  SizedBox(height: 20),
                  CircularProgressIndicator()
                ],
              ),
            ),
    );
  }

  Future<Account> getAccount() async {
    final accountResponse = await authorizedGetRequest(
        Uri.parse('${AppConstant.baseUrl}/api/account'),
        {'Content-Type': 'application/json'});
    final account =
        DDNApp.account = Account.fromJson(jsonDecode(accountResponse.body));
    return account;
  }

  Future<UserInfo> getUserInfo() async {
    final accountResponse = await authorizedGetRequest(
        Uri.parse('${AppConstant.baseUrl}/api/account'),
        {'Content-Type': 'application/json'});
    final account = Account.fromJson(jsonDecode(accountResponse.body));
    final userInfoResponse = await authorizedGetRequest(
        Uri.parse(
            '${AppConstant.baseUrl}/api/user-info/get-user-infos-by-login/${account.login}'),
        {'Content-Type': 'application/json'});
    final userInfo =
        DDNApp.userInfo = UserInfo.fromJson(jsonDecode(userInfoResponse.body));
    return userInfo;
  }

  _getLatLongAlt() async {
    try {
      Position position = await _determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
      altitude = position.altitude;
      setState(() {
        _latLongAltSet = true;
      });
    } catch (e) {}
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
