

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../responsive.dart';
import '../controllers/bookings_controller.dart';

class SelectedAppointmentView extends GetView<BookingsController> {

  double textSize = Responsive.isMobile(Get.context) ? 14 : 20;
  double boxSize = Responsive.isMobile(Get.context) ? 14 : 20;
  var width = Responsive.isMobile(Get.context) ? Get.width/2.2 : Get.width/3;
  double height = Responsive.isMobile(Get.context) ? 40 : 60;
  double total = 0.0;
  double bsHeight = Responsive.isMobile(Get.context) ? Get.height/3.8 : Get.height/4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Get.width/2,
        height: Get.height - Get.height/4,
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    children: [
                      Obx(() => Row(
                          children: [
                            Responsive.isMobile(Get.context) ?

                            Text(controller.selectedAppointment.isEmpty ? "" :
                            controller.selectedAppointment['name'],
                                style: TextStyle(fontSize: textSize, color: appColor, fontWeight: FontWeight.bold)) :
                            RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(text: "Détails de ", style: TextStyle(fontSize: textSize, color: appColor)),
                                      TextSpan(text: controller.selectedAppointment['name']
                                          , style: TextStyle(fontSize: textSize, color: appColor, fontWeight: FontWeight.bold))
                                    ]
                                )
                            ),
                            Spacer(),
                            if(controller.loadOrder.value)
                              SpinKitFadingCircle(color: employeeInterfaceColor, size: 30),
                            if(controller.selectedAppointment.isNotEmpty)
                              TextButton(
                                  onPressed: ()=> {
                                    controller.selectedAppointment.value = {},
                                    controller.orderDto.value = {}
                                  },
                                  child: Responsive.isMobile(Get.context) ?
                                  Icon(Icons.cancel_outlined, color: specialColor) :
                                  Text("Annuler", style: Get.textTheme.headline2.merge(TextStyle(color: specialColor))
                                  )
                              ),
                          ]
                      )),
                      SizedBox(height: 10),
                      if(controller.extraProducts.isNotEmpty && controller.selectedAppointment.isNotEmpty)...[
                        Expanded(
                          child: Obx(() =>
                              ListView.builder(
                                itemCount: controller.extraProducts.length,
                                itemBuilder: (context, index){

                                  List data = [];
                                  var item = controller.extraProducts[index];
                                  data.add(item);

                                  return Card(
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                              children: [
                                                Text(item['product_id'][1].split(">").first, style: TextStyle(fontSize: 17, color: appColor)),
                                                Spacer(),
                                                Text("${item['price_total']} EUR",
                                                    style: TextStyle(color: specialColor, fontWeight: FontWeight.bold, fontSize: 15)),
                                                SizedBox(width: 5),
                                                if(item.length > 1 && index != 0)
                                                  IconButton(
                                                    onPressed: (){
                                                      showDialog(
                                                          context: context,
                                                          builder: (_){
                                                            return showAlertDialog(context, item);
                                                          });
                                                    },
                                                    icon: Icon(Icons.delete),
                                                  ),
                                                SizedBox(width: 5),
                                              ]
                                          )
                                      )
                                  );
                                },
                              )
                          ),
                        )
                      ],
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.extraServices.length,
                          itemBuilder: (context, index){

                            List data = [];
                            var item = controller.extraServices[index];
                            data.add(item);
                            double duration = controller.servicesByCategory[index]["appointment_duration"] * 60;
                            return Card(
                                child: ListTile(
                                  title: Text(item['name'].split(">").first + ", \n$duration mins", style: TextStyle(fontSize: 14, color: appColor)),
                                  subtitle: Text("${item["product_price"]} €",
                                      style: TextStyle(color: specialColor, fontSize: 14)),
                                  trailing: Responsive.isMobile(Get.context) ?
                                  IconButton(
                                      onPressed: ()async{
                                        addProductLine(item);
                                      },
                                      icon: Icon(Icons.check_box_rounded, size: 30,color: interfaceColor)
                                  )
                                      : ElevatedButton(
                                      onPressed: (){
                                        addProductLine(item);
                                      },
                                      child: Text('Confirmer')
                                  ),
                                )
                            );
                          },
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }

  Future addProductLine(var item)async{
    var data = json.encode({
      "product_id": item["product_id"],
      "appointment_id": controller.selectedAppointment['id'],
      "product_uom_qty": 1,
      "from_web_mobile": true
    });
    controller.loadOrder.value = true;
    controller.
    addProductLine(item['id'], item, data);
  }

  Widget showAlertDialog(BuildContext context, item) {
    return AlertDialog(
        title: Column(
            children: [
              Icon(Icons.warning_amber_outlined,
                  size: 50, color: inactive),
              SizedBox(height: 10),
              Text("Confirmer l'Action"),
            ]
        ),
        backgroundColor: Color(0xFFE5F0FA),
        scrollable: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        content: Container(
          //color: Palette.background
            width: Get.width/2,
            height: 100,
            child: Column(
                children: [
                  Text("Voulez-vous vraiment Supprimer cette ligne?", style: Get.textTheme.headline4),
                  SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            icon: Icon(
                              Icons.close,
                              size: 14,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: inactive),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            label: Text("Annuler")),
                        SizedBox(width: 20),
                        ElevatedButton.icon(
                            icon: Icon(
                                Icons.delete,
                                size: 14
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: specialColor),
                            onPressed: () {
                              String value = '';
                              String type = "";
                              if(controller.selectedAppointment['product_discount_id'] != false){
                                type = controller.selectedAppointment['product_discount_id'][1].split(" ").first;
                              }
                              if(item['product_id'][1].contains("Bonus de ")){
                                value = "Bonus";
                              }else{
                                if(item['product_id'][1].split(">").first.contains(type)){
                                  value = "Réduction";
                                }
                              }
                              controller.removeLine(item['id'], value);
                            },
                            label: Text("Suprimer")),
                      ]
                  ),
                ]
            )
        )
    );
  }

}