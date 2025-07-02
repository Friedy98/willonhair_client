
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../../common/ui.dart';
import '../../../../../color_constants.dart';
import '../../../../responsive.dart';
import '../../home/controllers/home_controller.dart';
import '../controller/validation_controller.dart';
import 'num_pad.dart';

class AttributionView extends GetView<ValidationController> {

  double textSize = Responsive.isMobile(Get.context) ? 14 : 20;
  double textHSize = Responsive.isMobile(Get.context) ? 16 : 30;
  double buttonSize = Responsive.isMobile(Get.context) ? 80 : 120;
  double floatingButtonSize = Responsive.isMobile(Get.context) ? 70 : 100;
  double height = Responsive.isMobile(Get.context) ? 40 : 60;
  double textFieldHeight = Responsive.isMobile(Get.context) ? 50 : 80;
  List bookings = [];

  @override
  Widget build(BuildContext context) {

    Get.lazyPut(()=>HomeController());

    return Scaffold(
        backgroundColor: Get.theme.colorScheme.secondary,
        resizeToAvoidBottomInset: true,
        floatingActionButton: InkWell(
            onTap: ()=> controller.scan(),
            child: Container(
                width: floatingButtonSize,
                height: floatingButtonSize,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/img/qr-code.png'))
                )
            )
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          padding: EdgeInsets.all(10),
          decoration: Ui.getBoxDecoration(color: backgroundColor),
          child: SingleChildScrollView(
            child: Obx(() => Column(
              children: [
                SizedBox(height: height),
                controller.found.value ?
                  ListTile(
                    title: Text(controller.client['name'], style: Get.textTheme.headline4.merge(TextStyle(fontSize: textSize))),
                    subtitle: Text("Points: ${controller.client['client_points']}, Bonus: ${controller.client['client_bonus']}", style: Get.textTheme.headline2.merge(TextStyle(fontSize: 20))),
                  ) : ListTile(
                  leading: Icon(Icons.info_outline, size: 30,),
                  title: Text("Scanner le code Qr pour attribuer des points", style: Get.textTheme.headline4.merge(TextStyle(fontSize: textSize))),
                ),
                SizedBox(height: 20),
                Text("Nombre de points: ", style: TextStyle( fontSize: textHSize)),
                SizedBox(height: 20),
                SizedBox(
                  height: textFieldHeight,
                  width: Get.width/2,
                  child: Center(
                      child: TextFormField(
                        controller: controller.pointController,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: controller.noValue.value ? specialColor.withOpacity(0.2) : Palette.background
                        ),
                        style: const TextStyle(fontSize: 40),
                        keyboardType: TextInputType.none,
                      )),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    width: Get.width/1.15,
                    height: Get.height/2,
                    child: NumPad(
                      buttonSize: buttonSize,
                      buttonColor: Colors.white,
                      iconColor: Colors.blueGrey,
                      controller: controller.pointController,
                      delete: () {
                        controller.pointController.text = controller.pointController.text
                            .substring(0, controller.pointController.text.length - 1);
                      },
                      // do something with the input numbers
                      onSubmit: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              content: Text(
                                "You number is ${controller.pointController.text}",
                                style: const TextStyle(fontSize: 30),
                              ),
                            ));
                      },
                    )
                ).marginOnly(bottom: 20),
                Obx(() {
                    if(controller.found.value){
                      return Container(
                          padding: EdgeInsets.all(10),
                          width: Get.width /2,
                          height: textFieldHeight,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: inactive
                          ),
                          child: controller.isLoading.value ? Center(
                              child: SpinKitFadingCircle(color: employeeInterfaceColor, size: 20)
                          ) : Center(child: Text("ATTRIBUER", style: TextStyle(color: Palette.background, fontSize: 20)))
                      );
                    }else{
                      return InkWell(
                          onTap: (){
                            var points = controller.client['client_points'] + int.parse(controller.pointController.text);
                            if(controller.pointController.text.isNotEmpty){
                              int partner = int.parse(controller.qrValue.value);
                              controller.isLoading.value = true;
                              controller.attributePoints(partner, points);
                            }else{
                              controller.noValue.value = true;
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              width: Get.width /2,
                              height: textFieldHeight,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: primaryColor
                              ),
                              child: controller.isLoading.value ? Center(
                                  child: SpinKitFadingCircle(color: employeeInterfaceColor, size: 30)
                              ) : Center(child: Text("ATTRIBUER", style: TextStyle(color: Palette.background, fontSize: 20)))
                          )
                      );
                    }
                  }),
              ]
            ))
          )
        )
    );
  }
}
