import 'package:bunpod_client/bunpod_client.dart';
import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

late final Client client;

late String serverUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (details) => FriendlyErrorView(details: details);

  final String serverUrl = await getServerUrl();

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  setupLocator();

  runApp(const App());
}
