import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_bus/event_bus.dart';

class AppManager {
  static const String ACCOUNT = "accoutName";
  static EventBus eventBus = EventBus();
  static SharedPreferences? prefs;

  static initApp() async {
    prefs = await SharedPreferences.getInstance();
  }

  static isLogin() {
    return prefs?.getString(ACCOUNT) != null;
  }
}
