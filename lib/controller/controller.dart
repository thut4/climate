import 'package:get/get.dart';
import 'package:weather_app/repository/api_services.dart';
import 'package:weather_app/screen/home_page.dart';

class HomeController extends GetxController {
  ApiProvider apiProvider = ApiProvider();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    apiProvider.getData();
  }
}
