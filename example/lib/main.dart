import 'dart:async';
import 'dart:core';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Credentials _credentials;

  set credentials(Credentials value) {
    _credentials = value;

    print('ACCESS TOKEN:');
    print(_credentials?.accessToken);

    print('ID TOKEN:');
    print(_credentials?.idToken);
  }

  final _dotEnv = DotEnv();
  Auth0 _auth0;
  CredentialsManager _credManager;
  WebAuth _webAuth;

  bool _credentialsStored = false;

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Credentials creds;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await _dotEnv.load('assets/.env');

      //   final clientId = _dotEnv.env['CLIENT_ID'];
      //   final domain = _dotEnv.env['DOMAIN'];
      //   final audience = _dotEnv.env['AUDIENCE'];

      final audience = 'https://api.cimpress.io/';
      final clientId = 'rB6m3d5LcaVi0zV6wqHvA8xuekDyTNKK';
      final domain = 'cimpress.auth0.com';

      _auth0 = Auth0(clientId: clientId, domain: domain);
      _credManager = _auth0.credentialsManager();
      _webAuth = _auth0.webAuth().audience(audience).scope('openid email offline_access');

      await _credManager.enableBiometrics(title: "Secure all the things");

      creds = await _credManager.getCredentials();
      _credentialsStored = await _credManager.hasValidCredentials();
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
      credentials = creds;
    });
  }

  Future<Credentials> webAuth() async {
    try {
      return await _webAuth.start();
    } on WebAuthError catch (e) {
      print(e);

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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_credentials != null) ...[
                  Text('Access Token:'),
                  Text(_credentials.accessToken),
                  FlatButton(
                    color: Colors.blueGrey,
                    child: Text(_credentialsStored ? 'Clear Credentials' : 'Store Credentials'),
                    onPressed: () async {
                      if (_credentialsStored) {
                        await _credManager.clearCredentials();

                        credentials = null;
                      } else {
                        await _credManager.storeCredentials(_credentials);
                      }

                      _credentialsStored = await _credManager.hasValidCredentials();

                      setState(() {});
                    },
                  )
                ] else
                  Center(
                    child: FlatButton(
                      color: Colors.blueGrey,
                      child: Text('Open Web Auth'),
                      onPressed: () async {
                        credentials = await webAuth();

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
