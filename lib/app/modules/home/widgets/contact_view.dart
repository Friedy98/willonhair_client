import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/home_controller.dart';

class ContactWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: AlertDialog(
        title: Text("Contacter le salon", style: Get.textTheme.headline1),
        content: Text('Vous souhaitez conatcter le service WillOnHair au +32 65 42 78 60', style: Get.textTheme.headline4),
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
                    Uri phone = Uri.parse('tel:+3265427860');

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
