
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

class MyUser {
  int id;
  int userId;
  String name;
  String email;
  String street;
  String password;
  String phone;
  String birthday;
  String birthplace;
  String sex;
  String image;
  var partnerAttachmentIds;
  var deviceTokenIds;


  MyUser({
    this.id,
    this.userId,
    this.name,
     this.email,
    this.street,
    this.password,
     this.phone,
     this.birthday,
    this.birthplace,
     this.sex,
    this.image,
    this.partnerAttachmentIds,
    this.deviceTokenIds,

  });

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
    id: json["id"],
    userId: json['partner_id'],
    name: json["name"] ,
    email: json["email"],
    street: json["street"],
    password: json["password"],
    phone: json["phone"],
    birthday: json["birthday"],
    birthplace: json["birthplace"],
    sex: json["sex"],
    image: json["image_1920"],
  );

  Map<String, dynamic> toJson() => {
    "partner_id": id,
    "name": name,
    "email": email,
    "street": street,
    "password": password,
    "phone": phone,
    "birthday": birthday,
    "birthplace": birthplace,
    "sex": sex,

  };

  PhoneNumber getPhoneNumber() {
    this.phone = this.phone.replaceAll(' ', '');
    String dialCode1 = this.phone.substring(1, 2);
    String dialCode2 = this.phone.substring(1, 3);
    String dialCode3 = this.phone.substring(1, 4);
    for (int i = 0; i < countries.length; i++) {
      if (countries[i].dialCode == dialCode1) {
        return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode1, number: this.phone.substring(2));
      } else if (countries[i].dialCode == dialCode2) {
        return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode2, number: this.phone.substring(3));
      } else if (countries[i].dialCode == dialCode3) {
        return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode3, number: this.phone.substring(4));
      }
    }
  }
}
