import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

Future<(SharedPreferences, SharedPreferencesAsync)>
initializeSharedPreferences() async {
  SharedPreferences.setMockInitialValues({});

  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  return (await SharedPreferences.getInstance(), SharedPreferencesAsync());
}
