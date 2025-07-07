import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../responsive.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/bookings_controller.dart';

import '../widgets/bookings_list_item_widget.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/selected_appointment.dart';
import '../widgets/services_widget.dart';

class InterfacePOSView extends GetView<BookingsController> {

  var crossAxisCount = Responsive.isMobile(Get.context) ? 1 : 2;
  double mainAxisExtent = Responsive.isMobile(Get.context) ? 80 : 200;
  double textSize = Responsive.isMobile(Get.context) ? 14 : 20;

  @override
  Widget build(BuildContext context) {

    Get.lazyPut(() => AuthController());

    return Scaffold(
        backgroundColor: background,
        resizeToAvoidBottomInset: true,
        bottomSheet: BottomSheetView(),
        body: RefreshIndicator(
            onRefresh: () async {
              controller.refreshBookings();
            },
            child:  Obx(() =>
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        children: [
                          Container(
                              padding: EdgeInsets.all(10),
                              width: Responsive.isMobile(context) ? Get.width/1.5 : Get.width/2,
                              height: 70,
                              child: TextFormField(
                                controller: controller.searchController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: backgroundColor,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                    hintText: "Rechercher des services",
                                    contentPadding: EdgeInsets.all(10),
                                    hintStyle: TextStyle(fontSize: 12),
                                    suffixIcon: InkWell(
                                        child: Container(
                                          height: 35,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(5),
                                                bottomRight: Radius.circular(5)
                                            ),
                                            color: Colors.blue,
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Center(
                                              child: Icon(!controller.search.value ? Icons.search : Icons.close, color: Palette.background)
                                          ),
                                        ),
                                        onTap: ()async{
                                          if(controller.search.value){
                                            controller.search.value = !controller.search.value;
                                            controller.items.clear();
                                            controller.items.addAll(controller.allServices);
                                            controller.searchController.clear();
                                          }
                                        }
                                    )
                                ),
                                onChanged: (value) {
                                  controller.filterSearchServices(value);
                                },
                              )
                          ),
                          if(!Responsive.isMobile(context)) Spacer(),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: employeeInterfaceColor),
                                  onPressed: (){

                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) => BookingsListItemWidget()
                                    );
                                    controller.refreshEmployeeBookings();
                                  },
                                  icon: Icon(Icons.recommend).paddingSymmetric(vertical: 10),
                                  label: Responsive.isMobile(context) ? SizedBox.shrink() :
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Commandes"))
                              )).marginOnly(right: 10),
                        ]
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ServicesWidgetView(),
                          SelectedAppointmentView()
                        ]
                    )
                  ]
                )
            )
        )
    );
  }
}
