import 'package:app/app/models/parents/model.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../common/uuid.dart';
import '../services/settings_service.dart';

class User extends Model {
  String name;
  String email;
  String password;
  String apiToken;
  String deviceToken;
  String phoneNumber;
  bool verifiedPhone;
  String verificationId;
  String address;
  String bio;

  bool auth;

  User({this.name, this.email, this.password, this.apiToken, this.deviceToken, this.phoneNumber, this.verifiedPhone, this.verificationId, this.address, this.bio});

  User.fromJson(Map<String, dynamic> json) {
    name = stringFromJson(json, 'name');
    email = stringFromJson(json, 'email');
    apiToken = stringFromJson(json, 'api_token');
    deviceToken = stringFromJson(json, 'device_token');
    phoneNumber = stringFromJson(json, 'phone_number');
    verifiedPhone = boolFromJson(json, 'phone_verified_at');
    auth = boolFromJson(json, 'auth');
    try {
      address = json['custom_fields']['address']['view'];
    } catch (e) {
      address = stringFromJson(json, 'address');
    }
    try {
      bio = json['custom_fields']['bio']['view'];
    } catch (e) {
      bio = stringFromJson(json, 'bio');
    }
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    if (password != '') {
      data['password'] = this.password;
    }
    data['api_token'] = this.apiToken;
    data["device_token"] = deviceToken;
      data["phone_number"] = phoneNumber;
    if (verifiedPhone) {
      data["phone_verified_at"] = DateTime.now().toLocal().toString();
    }
    data["address"] = address;
    data["bio"] = bio;
    data['auth'] = this.auth;
    return data;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["device_token"] = deviceToken;
    return map;
  }

  PhoneNumber getPhoneNumber() {
    this.phoneNumber = this.phoneNumber.replaceAll(' ', '');
    String dialCode1 = this.phoneNumber.substring(1, 2);
    String dialCode2 = this.phoneNumber.substring(1, 3);
    String dialCode3 = this.phoneNumber.substring(1, 4);
    for (int i = 0; i < countries.length; i++) {
      if (countries[i].dialCode == dialCode1) {
        return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode1, number: this.phoneNumber.substring(2));
      } else if (countries[i].dialCode == dialCode2) {
        return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode2, number: this.phoneNumber.substring(3));
      } else if (countries[i].dialCode == dialCode3) {
        return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode3, number: this.phoneNumber.substring(4));
      }
    }
  }

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is User &&
      runtimeType == other.runtimeType &&
      name == other.name &&
      email == other.email &&
      password == other.password &&
      apiToken == other.apiToken &&
          deviceToken == other.deviceToken &&
          phoneNumber == other.phoneNumber &&
          verifiedPhone == other.verifiedPhone &&
          verificationId == other.verificationId &&
          address == other.address &&
          bio == other.bio &&
          auth == other.auth;

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      apiToken.hashCode ^
      deviceToken.hashCode ^
      phoneNumber.hashCode ^
      verifiedPhone.hashCode ^
      verificationId.hashCode ^
      address.hashCode ^
      bio.hashCode ^
      auth.hashCode;
}
