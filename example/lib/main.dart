import 'dart:core';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:auth0_flutter/auth0_flutter.dart';

void main() => runApp(MyApp());

final _clientId = '4rQXHhN6VX6GE00QY0kxHvJO5h1VyxNa';
final _domain = 'resideo.auth0.com';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Credentials _credentials;

  final _credManager =
      Auth0(clientId: _clientId, domain: _domain).credentialsManager();

  final _webAuth = Auth0(clientId: _clientId, domain: _domain)
      .webAuth()
      .scope('openid email offline_access');

  bool _credentialsStored = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Credentials credentials;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      credentials = await _credManager.getCredentials();
    } on CredentialsManagerError catch (e) {
      print(e.type);
      print(e.description);

      credentials = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _credentials = credentials;
    });
  }

  Future<Credentials> webAuth() async {
    try {
      return _webAuth.start();
    } on WebAuthError catch (e) {
      print(e.type);
      print(e.description);

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_credentials != null) ...[
                  Text(
                    'accessToken: ${_credentials.accessToken}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'tokenType: ${_credentials.tokenType}',
                    textAlign: TextAlign.center,
                  ),
                  FlatButton(
                    color: Colors.blueGrey,
                    child: Text(_credentialsStored
                        ? 'Clear Credentials'
                        : 'Store Credentials'),
                    onPressed: () async {
                      if (_credentialsStored) {
                        await _credManager.clearCredentials();
                        _credentials = null;
                      } else {
                        await _credManager.storeCredentials(_credentials);
                      }

                      _credentialsStored =
                          await _credManager.hasValidCredentials();

                      setState(() {});
                    },
                  )
                ] else
                  Center(
                    child: FlatButton(
                      color: Colors.blueGrey,
                      child: Text('Open Web Auth'),
                      onPressed: () async {
                        _credentials = await webAuth();

                        print(_credentials?.accessToken);

                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
