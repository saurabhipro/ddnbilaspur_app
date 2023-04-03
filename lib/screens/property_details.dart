import 'package:ddnbilaspur_mob/screens/survey_basic.dart';
import 'package:flutter/material.dart';

import '../ddn_app.dart';
import '../model/property.model.dart';

class PropertyDetailsView extends StatefulWidget {
  const PropertyDetailsView({Key? key, required this.property})
      : super(key: key);
  final Property property;

  @override
  State<PropertyDetailsView> createState() => _PropertyDetailsViewState();
}

class _PropertyDetailsViewState extends State<PropertyDetailsView> {
  final ddnStringController = TextEditingController();
  final propertyUidController = TextEditingController();
  final wardNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final mobileController = TextEditingController();

  @override
  void initState() {
    ddnStringController.text = widget.property.ddnString!;
    propertyUidController.text = widget.property.propertyUid!;
    wardNameController.text = widget.property.ward!.wardName!;
    ownerNameController.text = widget.property.propertyDetails == null
        ? 'Property Details Not Available'
        : (widget.property.propertyDetails!.ownerName == null
            ? ''
            : widget.property.propertyDetails!.ownerName!);
    mobileController.text = widget.property.mobileNumber!;
    super.initState();
  }

  @override
  void dispose() {
    ddnStringController.dispose();
    propertyUidController.dispose();
    wardNameController.dispose();
    ownerNameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String?> wards = [];
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      var ward = DDNApp.userInfo!.wards![i];
      wards.add(ward.wardNumber);
    }
    return Scaffold(
        appBar: AppBar(
            title: Column(
          children: [
            Center(
              child: Text(
                  '${DDNApp.account!.firstName} ${DDNApp.account!.lastName}',
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Center(
              child: Text('Wards: $wards',
                  style: const TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: ddnStringController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'DDN String',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: propertyUidController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'PropertyUid',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: wardNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ward',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: ownerNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Owner Name',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: mobileController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (widget.property.surveyed == null ||
                  !widget.property.surveyed!)
                Row(
                  children: [
                    const SizedBox(width: 10),
                    (widget.property.surveyed == null)
                        ? Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SurveyBasic(
                                            property: widget.property)));
                              },
                              child: const Text(
                                'Start Survey',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          )
                        : const Text('Test'),
                    const Spacer(),
                    TextButton(
                        onPressed: () {}, child: const Text('Not Available')),
                    const SizedBox(width: 10)
                  ],
                )
            ],
          ),
        ));
  }
}
