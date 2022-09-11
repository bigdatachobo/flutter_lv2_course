import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN_KEY';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN_KEY';

// localhost
// ngrok https://cc96-61-74-115-199.jp.ngrok.io
const emulatorIp = '10.0.2.2.:3000';
// const simulatorIp = '192.168.50.251:3000';
const simulatorIp = 'e8e1-61-74-115-199.jp.ngrok.io';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;

final storage = FlutterSecureStorage();
