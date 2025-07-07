import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../color_constants.dart';
import '../../../../common/animation_controllers/animation.dart';
import '../../../../responsive.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_services.dart';
import '../../global_widgets/drawer_link_widget.dart';
import '../controllers/bookings_controller.dart';

class PartnersView extends GetView<BookingsController> {

  @override
  Widget build(BuildContext context) {

    double size = Responsive.isMobile(context) ? 35 : 50;
    double width = Responsive.isMobile(context) ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width / 4;

    var data = [];
    for(var a in controller.items){
      if(a['state'] == "reserved"){
        data.add(a);
      }
    }
    return DelayedAnimation(
        delay: 50,
        child: Container(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 4, right: 0),
            child: Drawer(
                backgroundColor: Palette.background,
                child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios_rounded)
                          ),
                          if(!Responsive.isMobile(context))...[
                            Text(" Tous les Clients", style: TextStyle(color: appColor, fontSize: 17, fontWeight: FontWeight.bold)),
                            Spacer(),
                          ],
                          Container(
                              width: width,
                              height: 40,
                              child: TextFormField(
                                //controller: dateController,
                                decoration: InputDecoration(
                                  filled: true,
                                  contentPadding: EdgeInsets.only(top: 10),
                                  fillColor: background,
                                  prefixIcon: Icon(Icons.search),
                                  hintText: "Rechercher par nom du client",
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme
                                        .of(context)
                                        .hintColor,
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
                                ),
                                onChanged: (value) {
                                  controller.filterSearchResults(value);
                                },
                              )
                          ),
                          SizedBox(width: 10)
                        ],
                      ),
                      Divider(color: Colors.grey),
                      controller.clientId.value != 0 ?
                      DrawerLinkWidget(
                          special: false,
                          drawer: false,
                          icon: Icons.add,
                          text: "Prendre rendez-vous",
                          onTap: (e){
                            Navigator.pop(context);
                            Get.toNamed(Routes.APPOINTMENT_BOOKING_FORM);
                          }
                      ) : SizedBox.shrink(),
                      controller.clientsLoading.value ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.width / 4),
                            SpinKitFadingCircle(color: employeeInterfaceColor, size: 40),
                          ]
                      ) : controller.clients.isNotEmpty ?
                      Expanded(
                          child: ListView.builder(
                              itemCount: controller.clients.length,
                              itemBuilder: (BuildContext context, int index) {
                                var list = [];
                                list = controller.clients;

                                return Column(
                                    children: [
                                      Material(
                                          child: InkWell(
                                              onTap: ()async{

                                                controller.selectedClient.value = index;
                                                controller.clientId.value = list[index]['id'];
                                                //getOrder(controller.items[index]['order_id'][0]['id'], );
                                              },
                                              child: Card(
                                                  margin: EdgeInsets.all(5),
                                                  color: controller.selectedClient.value == index && controller.clientId.value != 0
                                                      ? primaryColor.withOpacity(0.5) : Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Row(
                                                        children: [
                                                          ClipOval(
                                                              child: FadeInImage(
                                                                width: size,
                                                                height: size,
                                                                fit: BoxFit.cover,
                                                                image: Domain.googleUser ? NetworkImage(Domain.googleImage) :
                                                                NetworkImage('${Domain.serverPort}/image/res.partner/${list[index]['id']}/image_1920?unique=true&file_response=true',
                                                                    headers: Domain.getTokenHeaders()),
                                                                placeholder: AssetImage(
                                                                    "assets/img/loading.gif"),
                                                                imageErrorBuilder:
                                                                    (context, error, stackTrace) {
                                                                  return Image.asset(
                                                                      'assets/img/téléchargement (3).png',
                                                                      width: size,
                                                                      height: size,
                                                                      fit: BoxFit.fitWidth);
                                                                },
                                                              )
                                                          ),
                                                          SizedBox(width: 10),
                                                          RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(text: list[index]['name'],
                                                                      style: TextStyle(fontSize: 18, color: appColor)),
                                                                  TextSpan(text: list[index]['email'].toString() != "false" ?
                                                                  "\n${list[index]['email']}" : "",
                                                                      style: TextStyle(fontSize: 15, color: CupertinoColors.systemGrey)),
                                                                ]
                                                            )
                                                          )
                                                        ]
                                                    ),
                                                  )
                                              )
                                          )
                                      )
                                    ]
                                );
                              }
                          )
                      ) : Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.width / 4),
                            Text("Page vide", style: TextStyle(color: inactive))
                          ]
                      )
                    ]
                ))
            )
        )
    );
  }
}
