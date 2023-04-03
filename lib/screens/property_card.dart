import 'package:ddnbilaspur_mob/model/property.model.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({Key? key, required this.property}) : super(key: key);
  final Property property;

  @override
  Widget build(BuildContext context) {
    var backGroundColour;
    if (property.propertyStatus == 'DOWNLOADED' || property.propertyStatus == 'VISIT_AGAIN') {
      backGroundColour = Colors.deepOrangeAccent;
    }
    if(property.propertyStatus == 'INSTALLED') {
      backGroundColour = Colors.lightGreen;
    }
    if(property.propertyStatus == 'NEW') {
      backGroundColour = Colors.blueGrey;
    }
    if(property.propertyStatus == 'ARI_APPROVED') {
      backGroundColour = Colors.blue;
    }
    return Container(
      width: 200,
      decoration:  BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: backGroundColour),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              (property.propertyDetails == null
                  ? 'Property Details not found!'
                  : (property.propertyDetails!.ownerName ??
                      'Owner Name not found!')),
              style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              (property.propertyDetails == null
                  ? 'Property Details not found!'
                  : (property.propertyDetails!.fatherName ??
                      'Father\'s Name not found!')),
              style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              property.propertyUid!,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
