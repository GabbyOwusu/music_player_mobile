import 'package:device_info/device_info.dart';

class DeviceInfoService {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<int> getDeviceInfo() async {
    var androidInfo = await deviceInfo.androidInfo;
    int sdkInt = androidInfo.version.sdkInt;
    return sdkInt;
  }
}
