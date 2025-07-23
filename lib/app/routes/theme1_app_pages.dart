import 'package:get/get.dart' show GetPage, Transition;
import '../modules/auth/views/politique.dart';
import '../modules/book_appointment/bindings/book_appointment_binding.dart';
import '../modules/book_appointment/views/book_appointment_form.dart';
import '../modules/fidelisation/binding/validation_Biding.dart';
import '../modules/fidelisation/views/attribute_points.dart';
import '../modules/home/views/employee_home.dart';
import '../modules/home/widgets/contact_view.dart';
import '../modules/home/widgets/fidelity_card_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/splash_view.dart';
import '../modules/auth/views/verification_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notification_details.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/rating/bindings/rating_binding.dart';
import '../modules/rating/views/rating_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/userBookings/views/bookings_view.dart';
import '../modules/userBookings/views/facturation.dart';
import '../modules/userBookings/views/interface_POS.dart';
import 'app_routes.dart';

class Theme1AppPages {
  static const INITIAL = Routes.SPLASH_VIEW;

  static final routes = [
    GetPage(name: Routes.SPLASH_VIEW, page: () => SplashView(), binding: AuthBinding()),
    GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding()),
    GetPage(name: Routes.RATING, page: () => RatingView(), binding: RatingBinding()),
    GetPage(name: Routes.APPOINTMENT_BOOKING_FORM, page: () => AppointmentBookingView(), binding: AppointmentBookingBinding(), transition: Transition.leftToRight),

    GetPage(name: Routes.CONTACT, page: () => ContactWidget(), transition: Transition.fadeIn),
    GetPage(name: Routes.INTERFACE_POS, page: () => InterfacePOSView(), transition: Transition.fadeIn),
    GetPage(name: Routes.EMPLOYEE_HOME, page: () => EmployeeHomeView(), transition: Transition.fadeIn),
    GetPage(name: Routes.APPOINTMENT_BOOK, page: () => BookingsView(), transition: Transition.fadeIn),
    GetPage(name: Routes.FIDELITY_CARD, page: () => FidelityCardWidget(),transition: Transition.fadeIn),
    GetPage(name: Routes.FACTURATION, page: () => EmployeeReceipt(),transition: Transition.fadeIn),

    GetPage(name: Routes.VALIDATE_TRANSACTION, page: () => AttributionView(), binding: ValidationBinding()),
    GetPage(name: Routes.LOGIN, page: () => LoginView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.REGISTER, page: () => RegisterView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordView(), binding: AuthBinding()),
    GetPage(name: Routes.VERIFICATION, page: () => VerificationView(), binding: AuthBinding()),
    GetPage(name: Routes.POLITIQUE, page: () => Politique(), binding: AuthBinding()),

    //GetPage(name: Routes.GALLERY, page: () => GalleryView(), binding: GalleryBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.NOTIFICATIONS, page: () => NotificationsView(), binding: NotificationsBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.NOTIFICATION_DETAIL, page: () => NotificationDetailsView(), binding: NotificationsBinding(), transition: Transition.fadeIn),
    //GetPage(name: Routes.WALLETS, page: () => WalletsView(), binding: WalletsBinding(), middlewares: [AuthMiddleware()]),
    //GetPage(name: Routes.WALLET_FORM, page: () => WalletFormView(), binding: WalletsBinding(), middlewares: [AuthMiddleware()]),
  ];
}
