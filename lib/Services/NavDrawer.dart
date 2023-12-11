import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawer();
}

class _NavDrawer extends State<NavDrawer> {

  final websiteUri=Uri.parse('https://sairamincubation.com/');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(1000)),
        ),
        child: Drawer(
          width:
              MediaQuery.of(context).size.width * 0.65, //<-- width controller
          child:  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context),
                // buildCompany(context),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () => _onBackpressed(context),
    );
  }
  

////////////--------------------------Exit button Code-----------------/////////////
  Future<bool> _onBackpressed(BuildContext context) async {
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Really?"),
            content: const Text("Do you want to exit the App?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  //Navigator.of(context).pop(true);
                  exit(0);
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              )
            ],
          );
        });
    return exitApp ?? false;
  }

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.group_solid),
              title: Text('About us',
                  style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold)),
              onTap: () async {
                // var url = 'https://sairamincubation.com/';

                // // ignore: deprecated_member_use
                // if (await canLaunch(url)) {
                //   await launch(
                //     url,
                //     forceSafariVC: true,
                //     forceWebView: true,
                //     enableJavaScript: true,
                //   );
                // }
                launchUrl(websiteUri,mode:LaunchMode.inAppWebView);
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 15, 9, 9),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text(
                'Exit',
                style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold),
              ),
              onTap: () => _onBackpressed(context),
            ),
          ],
        ),
      );

      Widget buildHeader(BuildContext context) => Container(
        child: Padding(
          padding: EdgeInsets.only(top:25,bottom: 50),
          child: Image.asset('assets/Images/incubationlogo.png',width: 25),
        ),
        padding: const EdgeInsets.only(top: 25),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color.fromARGB(222, 255, 255, 255), Color.fromARGB(239, 181, 190, 243)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        )),
      );
}
