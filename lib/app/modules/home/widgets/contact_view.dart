import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/home_controller.dart';

class ContactWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: AlertDialog(
        title: Text('Vous souhaitez conatcter le service WillOnHair au +32 466 48 17 15', style: Get.textTheme.headline4),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: ()=> Navigator.pop(context),
                  child: Text('Annuler', style: Get.textTheme.headline2.merge(TextStyle(color: Colors.grey)))
              ),
              TextButton(
                  onPressed: () async{
                    Uri phone = Uri.parse('tel:+32466481715');

                    if (await launchUrl(phone)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('contacter', style: Get.textTheme.headline2)
              )
            ],
          )
        ],
      ),
    );
  }
}
