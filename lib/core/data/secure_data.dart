import 'package:auto_asig/core/app/app_data.dart';

Future<void> writeSecureData(
    {required String key, required String value}) async {
  await secureStorage!.write(key: key, value: value);
}

Future<String?> readSecureData({required String key}) async {
  return await secureStorage!.read(key: key);
}

Future<void> deleteSecureData({required String key}) async {
  await secureStorage!.delete(key: key);
}

Future<Map<String, String>> readAllSecureData() async {
  return await secureStorage!.readAll();
}

Future<void> deleteAllSecureData() async {
  await secureStorage!.deleteAll();
}
