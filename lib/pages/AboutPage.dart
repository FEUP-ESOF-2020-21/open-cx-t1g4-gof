import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 45, maxWidth: 45),
                    child: Image(image: AssetImage('assets/InquireScapeLogo.png')),
                  ),
                  title: Text("InquireScape", style: TextStyle(fontSize: 30)),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text("Version: 0.3"),
                ),
                ListTile(
                  leading: Icon(Icons.source),
                  title: Text("Source Code"),
                  onTap: () => launchLink("https://github.com/FEUP-ESOF-2020-21/open-cx-t1g4-gof"),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Authors",
                  style: TextStyle(fontSize: 24),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("João Cardoso"),
                  onTap: () => launchLink("https://github.com/joaoalc"),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Ivo Saavedra"),
                  onTap: () => launchLink("https://github.com/ivSaav"),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Telmo Baptista"),
                  onTap: () => launchLink("https://github.com/Telmooo"),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Tiago Silva"),
                  onTap: () => launchLink("https://github.com/tiagodusilva"),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Special thanks to",
                  style: TextStyle(fontSize: 24),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Ademar Aguiar"),
                  subtitle: Text(
                    "Our teacher",
                  ),
                  onTap: () => launchLink("https://github.com/aaguiar"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void launchLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
