import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../responsive.dart';
import '../../../services/api_services.dart';
import '../controllers/bookings_controller.dart';

class ServicesWidgetView extends GetView<BookingsController> {


  var crossAxisCount = Responsive.isMobile(Get.context) ? 1 : 2;
  double mainAxisExtent = Responsive.isMobile(Get.context) ? 80 : 200;
  double width = Responsive.isMobile(Get.context) ? 100 : 200;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width/2,
      child: Column(
        children: [
          Container(
            width: Get.width/2.5,
            height: 50,
            margin: EdgeInsets.only(right: 10.0, top: 8.0),
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: employeeInterfaceColor,
            ),
            child: Center(
              child: Text(controller.userDto["resource_type_id"][1],
                style: TextStyle(
                    color: CupertinoColors.white, letterSpacing: 2),
              ),
            ),
          ),
          SizedBox(
            height: Get.height/1.7,
            child: Obx(() {
              if (controller.isLoading.value) {
                // Show loading indicator while loading
                return GridView.builder(
                  itemBuilder: (context, index){
                    return buildLoader();
                  },
                  itemCount: 10,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 190.0, crossAxisSpacing: 15.0, mainAxisSpacing: 15.0),
                );
              } else {
                // Show GridView of services
                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: controller.servicesByCategory.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount, // Adjust as needed
                    mainAxisExtent: mainAxisExtent,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    final service = controller.servicesByCategory[index];
                    double duration = service["appointment_duration"] * 60;

                    return InkWell(
                      onTap: () {
                        if (controller.extraServices.contains(service)) {
                          controller.extraServices.remove(service);
                        } else {
                          controller.extraServices.add(service);
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: controller.extraServices.contains(controller.servicesByCategory[index]) ? Border.all(width: 2, color: employeeInterfaceColor) : null,
                            color: controller.extraServices.contains(controller.servicesByCategory[index]) ? background : Colors.white,
                          ), 
                          child: !Responsive.isMobile(context) ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FadeInImage(
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  image: NetworkImage('${Domain.serverPort}/image/appointment.product/${controller.servicesByCategory[index]['id']}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                                  placeholder: AssetImage(
                                      "assets/img/loading.gif"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        'assets/img/photo_2022-11-25_01-12-07.jpg',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.fitWidth);
                                  },
                                ),
                                Text(controller.servicesByCategory[index]["name"].split(">").first + " $duration mins", style: Get.textTheme.headline4),
                                Text("${controller.servicesByCategory[index]["product_price"]} EUR", style: Get.textTheme.headline4)
                              ]
                          ) : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FadeInImage(
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  image: NetworkImage('${Domain.serverPort}/image/appointment.product/${controller.servicesByCategory[index]['id']}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                                  placeholder: AssetImage(
                                      "assets/img/loading.gif"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        'assets/img/photo_2022-11-25_01-12-07.jpg',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fitWidth);
                                  }
                                ),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(controller.servicesByCategory[index]["name"].split(">").first, style: Get.textTheme.headline4),
                                      Text("$duration mins", style: Get.textTheme.headline4),
                                      Text("${controller.servicesByCategory[index]["product_price"]} EUR", style: Get.textTheme.headline4)
                                    ]
                                ).marginOnly(left: 10, top: 15)
                              ]
                          )
                      ),
                    );
                  },
                );
              }
            }).marginOnly(top: 10),
          ),
        ],
      ),
    );
  }

  Widget buildLoader() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Image.asset(
        'assets/img/loading.gif',
        fit: BoxFit.cover,
        width: 200,
        height: 100,
      ),
    );
  }

}