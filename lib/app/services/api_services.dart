
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Domain{
  static var serverPort = "https://willonhair.net/api/v1";
  static var serverPort2 = "https://willonhair.net/api";
  static var serverAddress = "https://willonhair.net";

  static PackageInfo packageInfo;
  static Future<void> initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  static var apiKey = "NMMAG3K4IVS0L6VYEPXLJ1Z0RR77AR67";

  static var myBoxStorage = Hive.box("notifications").obs;

  static var deviceToken;

  static var googleUser = false;
  static var googleImage = '';

  static var authorization = "Basic YWRtaW46YWRtaW4=";
  static var AppName = "Will On Hair";
  static Map<String, String> getTokenHeaders() {
    Map<String, String> headers = new Map();
    headers['Authorization'] = authorization;
    headers['accept'] = 'application/json';
    return headers;
  }
}