import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.lazyPut(()=>MyAuthService());
      Get.lazyPut<OdooApiClient>(
            () => OdooApiClient(),
      );
      return WillPopScope(
        onWillPop: Helper().onWillPop,
        child: Scaffold(
          //drawer: MainDrawerWidget(),
          body: controller.currentPage,
          bottomNavigationBar: CustomBottomNavigationBar(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            itemColor: context.theme.colorScheme.secondary,
            currentIndex: controller.currentIndex.value,
            onChange: (index) {
              controller.changePage(index);
            },
            children: [
              CustomBottomNavigationItem(
                icon: FontAwesomeIcons.home,
                label: "Accueil".tr,
              ),
              CustomBottomNavigationItem(
                icon: FontAwesomeIcons.fileLines,
                label: "Rendez-vous".tr,
              ),
              CustomBottomNavigationItem(
                icon: FontAwesomeIcons.qrcode,
                label: "Ma carte".tr,
              ),
              CustomBottomNavigationItem(
                icon: FontAwesomeIcons.userEdit,
                label: "Profile".tr,
              ),
            ],
          ),
        ),
      );
    });
  }
}
