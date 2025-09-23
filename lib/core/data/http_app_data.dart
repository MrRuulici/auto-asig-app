import 'package:auto_asig/core/app/app_data.dart';

Future<Map<String, bool>> getAppData() async {
  late bool isUpToDate;
  late bool isMaintenance;

  await appDataCollection!.doc('settings').get().then((value) {
    isUpToDate = false;
    isMaintenance = false;
    if (value.data() != null) {
      // Access the 'current' field in the version document
      final version = value.data()! as Map<String, dynamic>;

      // Set isMaintenance
      isMaintenance = version['in_maintenance'];

      print('online version: ${version['current']}');
      print('app version: $appVersion');

      // Compare the app version with the current version
      final int currentVersion = version['app_version'];

      if (appVersion == currentVersion) {
        print('App is up to date');
        isOldVersion = false;
        isUpToDate = true;
      } else {
        isUpToDate = false;
      }

      updateUrl = version['update_url'];
    }
  });

  return {'isUpToDate': isUpToDate, 'isMaintenance': isMaintenance};
}
