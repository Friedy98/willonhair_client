import 'package:get/get.dart';

import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../controllers/book_appointment_controller.dart';

class AppointmentBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentBookingController>(
          () => AppointmentBookingController(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
  }
}