import 'package:frontend_gesabsence/app/data/services/i_login_service.dart';
import 'package:frontend_gesabsence/app/data/services/springImpl/login_api_service.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ILoginApiService>(() => LoginApiServiceSpring());
  }
}
