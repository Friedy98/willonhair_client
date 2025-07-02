import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../services/api_services.dart';
import '../../../../responsive.dart';

class ValidationController extends GetxController {

  final isDone = false.obs;
  var isLoading = false.obs;
  final currentState = 0.obs;
  final validationType = 0.obs;
  var shipping = [].obs;
  var copyPressed = false.obs;
  var loading = false.obs;
  var client = {}.obs;
  var pointsToBonus = 0.obs;
  var found = false.obs;
  var noValue = false.obs;
  var scanned = false.obs;
  var qrValue = "".obs;
  TextEditingController pointController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(milliseconds: 300), () {
      scan();
    });
  }

  Future scan() async {
    try {
      ScanResult qrCode = await BarcodeScanner.scan();
      String qrResult = qrCode.rawContent;
      qrValue.value = qrResult;
      //setState(() => barcode = qrResult);
      var user = await getUserInfo(qrResult);
      client.value = user;

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        Get.log('The user did not grant the camera permission!');
      } else {
        Get.log('Unknown error: $e');
      }
    } on FormatException{
      Get.log('null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      Get.log('Unknown error: $e');
    }
  }

  Future getUserInfo(var id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': Domain.authorization,
    };
    var request = http.Request('GET', Uri.parse('${Domain.serverPort}/read/res.partner?ids=$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      found.value = true;
      return json.decode(data)[0];
    }
    else {
      print(response.reasonPhrase);
    }
  }

  void attributePoints(int partner, var point) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${Domain.serverAddress}/fidelity/partner/$partner/points/$point'));
    request.body = json.encode({
      "jsonrpc": "2.0"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.showSnackbar(Ui.InfoSnackBar(message: "Nombre de point mise a jour avec succès"));
    }
    else {
      isLoading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Une érreur est survenue!"));
    }
  }

  @override
  void onClose() {
    //chatTextController.dispose();
  }
}
