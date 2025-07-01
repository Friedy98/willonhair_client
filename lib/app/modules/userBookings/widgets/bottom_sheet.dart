
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../responsive.dart';
import '../controllers/bookings_controller.dart';

class BottomSheetView extends GetView<BookingsController> {

  double textSize = Responsive.isMobile(Get.context) ? 14 : 20;
  double boxSize = Responsive.isMobile(Get.context) ? 14 : 20;
  var width = Responsive.isMobile(Get.context) ? Get.width/2.2 : Get.width/3;
  double height = Responsive.isMobile(Get.context) ? 40 : 60;
  double total = 0.0;
  double bsHeight = Responsive.isMobile(Get.context) ? Get.height/3.8 : Get.height/4;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: bsHeight,
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: Get.width / 3,
                    child: Obx(() =>
                        RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(text: "Client Bonus: ", style: TextStyle(color: Colors.white, letterSpacing: 1, fontSize: textSize)),
                                  TextSpan(text: controller.selectedAppointment.isNotEmpty ? controller.clientBonus.value.toString() : "0.",
                                      style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: textSize, fontWeight: FontWeight.bold))
                                ]
                            )
                        )
                    )
                ),
                Spacer(),
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Obx(() =>
                        RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(text: "Total: ", style: TextStyle(color: Colors.white, letterSpacing: 1, fontSize: 20)),
                                  TextSpan(text: controller.selectedAppointment.isNotEmpty ? "${controller.price.value} EUR" : "0 EUR",
                                      style: TextStyle(color: validateColor, letterSpacing: 2, fontSize: textSize, fontWeight: FontWeight.bold))
                                ]
                            )
                        )
                    )
                )
              ]
          ),
          Divider(color: Colors.white, thickness: 1),
          //SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    width: width,
                    height: height,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage("assets/img/man.png"),
                                  )
                              )
                          ),
                          SizedBox(width: 10),
                          Obx(() => Expanded(
                              child: Text(controller.selectedAppointment['partner_id'] != null ? controller.selectedAppointment['partner_id'][1] : "ANONYME", style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: textSize), overflow: TextOverflow.ellipsis,
                              )
                          ))
                        ]
                    )
                ),
                InkWell(
                    onTap: ()=> {
                      if(controller.selectedAppointment.isNotEmpty){

                        showDialog(
                            context: context,
                            builder: (_){
                              return SpinKitFadingCircle(color: Colors.white, size: 50);
                            }),
                        controller.getResources()

                      }
                    },
                    child: Obx(() =>
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: controller.selectedAppointment['partner_id'] != null ? Colors.blue : inactive, width: 2),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            width: width,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            height: height,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/img/data-transfer.png"),
                                        )
                                    ),
                                  ),
                                  Text("TRANSFERER", style: TextStyle(color: controller.selectedAppointment['partner_id'] != null ? Colors.white : inactive, letterSpacing: 2, fontSize: textSize)
                                  ),
                                ],
                              ),
                            )
                        )
                    )
                )
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: (){

                      if(controller.selectedAppointment.isNotEmpty){
                        controller.getRemise();
                      }
                    },
                    child: Obx(() =>
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: controller.selectedAppointment['partner_id'] != null ? employeeInterfaceColor : inactive, width: 2),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            width: width,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            height: height,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          width: 30,
                                          height: 30,
                                          margin: EdgeInsets.only(left: 10, right: 10),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage("assets/img/offer.png"),
                                              )
                                          )
                                      ),
                                      Text("REMISE", style: TextStyle(color: controller.selectedAppointment['partner_id'] != null ? Colors.white : inactive, letterSpacing: 2, fontSize: textSize)
                                      )
                                    ]
                                )
                            )
                        )
                    )
                ),
                InkWell(
                    onTap: ()async{

                      if(controller.selectedAppointment.isNotEmpty && controller.clientBonus.value > 0){
                        await controller.getBonuses();
                      }

                    },
                    child: Obx(() =>
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: controller.selectedAppointment.isNotEmpty && controller.clientBonus.value > 0 ? employeeInterfaceColor : inactive, width: 2),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            width: width,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            height: height,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                width: 30,
                                                height: 30,
                                                margin: EdgeInsets.only(left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage("assets/img/gift.png"),
                                                    )
                                                )
                                            ),
                                            Text("Mes Bonus", style: TextStyle(color: controller.clientBonus.value > 0 && controller.selectedAppointment['partner_id'] != null ? Colors.white : inactive, letterSpacing: 2, fontSize: textSize))
                                          ]
                                      )
                                    ]
                                )
                            )
                        )
                    )
                )
              ]
          ),
          InkWell(
            onTap: (){
              if(controller.selectedAppointment.isNotEmpty){
                showDialog(
                    context: context,
                    builder: (_){
                      return showContext(context);
                    });
              }
            },
            child: Obx(() =>
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: height,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: controller.selectedAppointment.isNotEmpty ? employeeInterfaceColor : inactive,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(child: Text("TERMINER", style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: textSize))),
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget showContext(BuildContext context){
    return AlertDialog(
        title: Column(
          children: [
            Icon(Icons.warning_amber_outlined,
                size: 60, color: inactive),
            SizedBox(height: 10),
            Text("Confirmer l'Action", style: Get.textTheme.headline2.merge(TextStyle(fontSize: 18, letterSpacing: 2))),
          ],
        ),
        backgroundColor: backgroundColor,
        scrollable: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        content: Container(
          //color: Palette.background,
            height: 120,
            child: Column(
                children: [
                  Text("Voulez-vous vraiment Terminer le rendez-vous ${controller.selectedAppointment['display_name']} ?", style: Get.textTheme.headline4),
                  SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            icon: Icon(
                              Icons.close,
                              size: 17,
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
                              Icons.check,
                              size: 17,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: validateColor),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_){
                                    return SpinKitFadingCircle(color: Colors.white, size: 50);
                                  });
                              controller.markDone();
                            },
                            label: Text("TERMINER")),
                      ]
                  )
                ]
            )
        )
    );
  }

}