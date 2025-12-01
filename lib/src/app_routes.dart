import 'package:get/get.dart';
import 'package:myapp/src/features/auth/bindings/auth_binding.dart';
import 'package:myapp/src/features/auth/views/login_view.dart';
import 'package:myapp/src/features/auth/views/signup_view.dart';
import 'package:myapp/src/features/home/bindings/scan_binding.dart';
import 'package:myapp/src/features/home/views/scanner_view.dart';


class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(name: '/', page: () => const LoginView(), binding: AuthBinding()),
    GetPage(name: '/signup', page: () => const SignupView(), binding: AuthBinding()),
    GetPage(
  name: '/scan',
  page: () => const ScanView(),
  binding: ScanBinding(),
),
  ];
}
