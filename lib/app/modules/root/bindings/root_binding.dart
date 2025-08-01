import 'package:get/get.dart';

import '../../../providers/odoo_provider.dart';
import '../../../services/my_auth_service.dart';
import '../../account/controllers/account_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../userBookings/controllers/bookings_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    Get.put(HomeController(), permanent: true);
    Get.put(BookingsController(), permanent: true);
    Get.lazyPut<BookingsController>(
      () => BookingsController(),
    );
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
    Get.lazyPut<MyAuthService>(
          () => MyAuthService(),
    );
    Get.lazyPut<OdooApiClient>(
          () => OdooApiClient(),
    );
  }
}
