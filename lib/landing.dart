import 'dart:async';
import 'package:drawapp/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrawApp',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Landing Page'),
        ),
        body: Center(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children:
            [Container(
              margin: const EdgeInsets.all(10),
              width: 300.0,
              height: 300.0,
              child: RaisedButton(
                child: Text('Yell and Paint!'),
                onPressed: () {
                  // Navigate to App when tapped.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DrawApp()),
                  );
                },
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: const EdgeInsets.all(10),
                  width: 300.0,
                  height: 150.0,
                  color: Colors.cyanAccent,
                  child: Linkify(
                  onOpen: _onOpen,
                  text: "https://aaell.github.io/ \n\nMail: aaron.elliot.dev@gmail.com \n\nView our privacy policy \n\n https://aaell.github.io/privacy.html  ",
                )
              ),
            ),

            ],
          ),
        )
      )
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

}

