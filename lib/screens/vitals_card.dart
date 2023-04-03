import 'package:ddnbilaspur_mob/model/device_vitals.model.dart';
import 'package:flutter/material.dart';

import '../ddn_app.dart';

class VitalsCard extends StatefulWidget {
  const VitalsCard({Key? key, required this.deviceVitals}) : super(key: key);
  final DeviceVitals deviceVitals;

  @override
  State<VitalsCard> createState() => _VitalsCardState();
}

class _VitalsCardState extends State<VitalsCard> {
  @override
  Widget build(BuildContext context) {
    List<String?> wards = [];
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      var ward = DDNApp.userInfo!.wards![i];
      wards.add(ward.wardNumber);
    }
    return Column(
      children: [
        Text('Longitude: ${widget.deviceVitals!.longitude.toString()}'),
        Text('Latitude: ${widget.deviceVitals!.latitude.toString()}'),
        Text('Altitude: ${widget.deviceVitals!.altitude.toString()}'),
      ],
    );
  }
}
