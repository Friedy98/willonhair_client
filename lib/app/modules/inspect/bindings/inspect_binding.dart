import 'package:get/get.dart';

import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../controllers/inspect_controller.dart';

class InspectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectController>(
          () => InspectController(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
  }
}