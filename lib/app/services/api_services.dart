
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Domain{
  static var serverPort = "http://51.91.252.155:8069/api/v1";
  static var serverPort2 = "http://51.91.252.155:8069/api";
  static var serverAddress = "http://51.91.252.155:8069";

  static PackageInfo packageInfo;

  static var apiKey = "NMMAG3K4IVS0L6VYEPXLJ1Z0RR77AR67";

  static var myBoxStorage = Hive.box("notifications").obs;

  static var deviceToken;

  static var googleUser = false;
  static var googleImage = '';
  static final riKey1 = new GlobalObjectKey<FormState>(1);

  static var authorization = "Basic YWRtaW46YWRtaW4=";
  static var AppName = "Will On Hair";
  static Map<String, String> getTokenHeaders() {
    Map<String, String> headers = new Map();
    headers['Authorization'] = authorization;
    headers['accept'] = 'application/json';
    return headers;
  }
}