import 'package:ddnbilaspur_mob/app-const/app_constants.dart';
import 'package:ddnbilaspur_mob/service/access_key.dart';
import 'package:ddnbilaspur_mob/service/http_request.service.dart';
import 'package:flutter/material.dart';

import '../ddn_app.dart';

class DrawerWidget extends StatelessWidget {
  final String appVersion;

  const DrawerWidget({Key? key, required this.appVersion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/icons/favicon.ico'), // Replace with your logo image
                ),
                const SizedBox(height: 8),
                const Text(
                  'DDN Bilaspur Survey App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version $appVersion',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              // navigate to the about us screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('Contact Us'),
            onTap: () {
              // navigate to the contact us screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.support),
            title: const Text('Support'),
            onTap: () {
              // navigate to the support screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () {
              // logout the user
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              AccessKeyStorage.storage.delete(key: AppConstant.jwtKeyName);
              DDNApp.navigatorKey.currentState?.pushNamed("/login");
            },
          ),
        ],
      ),
    );
  }
}
