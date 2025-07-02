import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../responsive.dart';
import '../../../services/api_services.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../fidelisation/controller/validation_controller.dart';
import '../../fidelisation/views/attribute_points.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../../userBookings/views/bookings_view.dart';
import '../../userBookings/views/facturation.dart';
import '../../userBookings/views/interface_POS.dart';
import '../controllers/home_controller.dart';

class EmployeeHomeView extends GetView<HomeController> {

  double textSize = Responsive.isMobile(Get.context) ? 14 : 30;
  double textHSize = Responsive.isMobile(Get.context) ? 18 : 30;
  double dataRowHeight = Responsive.isMobile(Get.context) ? 40 : 80;
  double headingRowHeight = Responsive.isMobile(Get.context) ? 30 : 60;
  double dataRowWidth = Responsive.isMobile(Get.context) ? 40 : 80;
  double size = Responsive.isMobile(Get.context) ? 20 : 40;
  double floatingButtonSize = Responsive.isMobile(Get.context) ? 70 : 100;

  @override
  Widget build(BuildContext context) {

    Get.lazyPut<AuthController>(
          () => AuthController(),
    );
    Get.lazyPut(()=>HomeController());
    Get.lazyPut(()=>RootController());
    Get.lazyPut(()=>BookingsController());
    Get.lazyPut(()=>ValidationController());

    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
          floatingActionButton: Obx(() => controller.currentPage.value == 0 ? InkWell(
              onTap: ()=>controller.currentPage.value = 4,
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
          ) : controller.currentPage.value != 4 ?
          FloatingActionButton(
                onPressed: (){
                  if(MediaQuery.of(context).orientation == Orientation.portrait)
                  {
                    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                  }else {
                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                  }
                },
                child: Icon(Icons.screen_rotation),
              ) : SizedBox()
          ),
          appBar: AppBar(
            backgroundColor: appBarColor,
            leading: IconButton(
              icon: Icon(Icons.sort, color: Colors.white),
              onPressed: ()
              => showDialog(
                context: context,
                builder: (_) {
                  return MainDrawerWidget();
                },
              ),
            ),
            title: Obx(() => Text( controller.currentPage.value == 0 ?
            Domain.AppName+", Tableau de bord" : controller.currentPage.value == 1 ? Domain.AppName+",  Mes rendez-vous"
                : controller.currentPage.value == 2 ? Domain.AppName+", Facturation" : controller.currentPage.value == 3 ? Domain.AppName+", Interface POS" : Domain.AppName+", Attribuer des points",
              style: Get.textTheme.headline6.merge(TextStyle(fontSize: textHSize, color: employeeInterfaceColor)),
            )),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [ NotificationsButtonWidget() ],
          ),
          backgroundColor: background,
          body: RefreshIndicator(

              onRefresh: ()=> controller.initValues(),

              child: FutureBuilder<bool>(
                future: controller.getData(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {

                    return SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: Obx(() => controller.currentPage.value == 0 ? build_dashboardView(context)
                          : controller.currentPage.value == 1 ? BookingsView()
                          : controller.currentPage.value == 2 ? EmployeeReceipt()
                          : controller.currentPage.value == 3 ? InterfacePOSView()
                          : AttributionView()
                      )
                    );
                  }
                }
              )
          )
      ),
    );
  }

  Widget build_dashboardView(BuildContext context){

    int hour = int.parse(DateFormat("HH").format(DateTime.now()).toString());
    var currentUser = Get.find<AuthController>().currentUser;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Obx(() => RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: hour > 12 ? "Bonsoir M/Mme ${currentUser['name']} 👋🏼" : "Bonjour M/Mme ${currentUser['name']} 👋🏼",
                              style: Get.textTheme.headline4.merge(TextStyle(color: appColor, fontSize: textSize))
                          ),
                          /*TextSpan(text: "\nVous avez ✅ ${appointmentsPaid.length} rendez-vous approuvés et ⏰ ${appointmentsPending.length} rendez-vous planifié",
                                        style: TextStyle(color: appColor, fontSize: 15)),*/
                        ]
                    )
                ))
            )
          ),
          Obx(() => Container(
            alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 50),
              child: PieChart(
                dataMap: {
                  "PLANIFIÉ": controller.planned.value,
                  "FAIT": controller.done.value,
                  "MANQUÉ": controller.missed.value,
                  "ANNULÉ": controller.cancel.value,
                },
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 50,
                chartRadius: MediaQuery.of(context).size.width / 3.5,
                colorList: controller.colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: size,
                centerText: "Rendez-Vous",
                legendOptions: LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: Get.textTheme.headline4.merge(TextStyle(fontSize: textSize))
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
                // gradientList: ---To add gradient colors---
                // emptyColorGradient: ---Empty Color gradient---
              )
          )),
          SizedBox(height: 20),
          SizedBox(
            height: Get.height/1.4,
            width: Get.width,
            child: MyAppointments(context)
          )
        ]
      )
    );
  }

  Widget MyAppointments(BuildContext context){

    var length = controller.items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text("Rendez-vous en attente",
                style: Get.textTheme.headline2.merge(TextStyle(color: appColor, fontSize: textSize)
                )
            )
        ),
        SizedBox(height: 10),
        Expanded(
            child: DataTable2(
              columnSpacing: defaultPadding,
              headingRowColor: MaterialStateColor.resolveWith((states) => appBarColor),
              minWidth: 800,
              headingRowHeight: headingRowHeight,
              dataRowHeight: dataRowHeight,
              showCheckboxColumn: false,
              columns: [
                DataColumn(
                  label: Text("Référence", style: Get.textTheme.headline2.merge(TextStyle(fontSize: textSize, color: Colors.white))),
                ),
                DataColumn(
                  label: Text("Service", style: Get.textTheme.headline2.merge(TextStyle(fontSize: textSize, color: Colors.white))),
                ),
                DataColumn(
                  label: Text("Client", style: Get.textTheme.headline2.merge(TextStyle(fontSize: textSize, color: Colors.white))),
                ),
                DataColumn(
                  label: Text("Date/h", style: Get.textTheme.headline2.merge(TextStyle(fontSize: textSize, color: Colors.white))),
                ),
                DataColumn(
                  label: Text(""),
                ),
                DataColumn(
                  label: Text("State", style: Get.textTheme.headline2.merge(TextStyle(fontSize: textSize, color: Colors.white))),
                ),
              ],
              rows: List.generate(
                  length,
                      (index){
                    var bookingState = controller.items[index]['state'];
                    var start = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(controller.items[index]['datetime_start'])).toString();
                    var end = DateFormat("HH:mm").format(DateTime.parse(controller.items[index]['datetime_end'])).toString();
                    return DataRow(
                        onSelectChanged: (value)async{
                          showDialog(
                              context: context,
                              builder: (_){
                                return SpinKitFadingCircle(color: Colors.white, size: 50);
                              });

                          await controller.getServiceDto(controller.items[index]['service_id'][0], controller.items[index]);

                        },
                        cells: [
                          DataCell(Obx(() =>
                              Text(controller.items[index]["name"], style: Get.textTheme.headline4)
                          )),
                          DataCell(Obx(() =>
                              Text(controller.items[index]['service_id'][1].split(">").first, style: Get.textTheme.headline4)
                          )),
                          DataCell(Obx(() =>
                              Text(controller.items[index]['partner_id'][1], style: Get.textTheme.headline4)
                          )),
                          DataCell(Text("$start - $end", style: Get.textTheme.headline4)),
                          DataCell(SizedBox()),
                          DataCell(Obx(()=>
                              Text(controller.items[index]['state'].toUpperCase(), style: Get.textTheme.headline2.merge(
                                  TextStyle(color: bookingState == 'reserved' ? newStatus : bookingState == 'done' ? doneStatus : bookingState == 'cancel' ? inactive : specialColor)))
                          )
                          )
                        ]
                    );
                  }
              ),
            )
        )
      ],
    );
  }
}
