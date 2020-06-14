import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final storage = new FlutterSecureStorage();

  Future<bool> storeUserInformation(
      {String id,
      String name,
      String accessToken,
      String refreshToken,
      String phone}) async {
    try {
      await storage.write(key: 'id', value: id.toString());
      await storage.write(key: 'name', value: name);
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'refreshToken', value: refreshToken);
      await storage.write(key: 'phone', value: phone);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> getUserInformation({key}) async {
    if (key != null) return await storage.read(key: key);
    return await storage.readAll();
  }

  dynamic getUserInfo({key}) async {
    if (key != null) return await storage.read(key: key);
    return await storage.readAll();
  }

  Future<String> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  Future<String> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  Future<bool> refreshAccessToken(String accessToken) async {
    try {
      await storage.write(key: 'accessToken', value: accessToken);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateNotificationInfo(Map<String, dynamic> data) async {
    try {
      await storage.write(key: 'push_token', value: data['push_token']);
      await storage.write(key: 'device_id', value: data['device_id']);
      await storage.write(key: 'device_os', value: data['device_os']);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> clearAllData() async {
    try {
      await storage.deleteAll();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
