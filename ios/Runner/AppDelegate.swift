import Flutter
import UIKit
import FBSDKCoreKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }
    
    // Initialize Facebook SDK (Updated API for newer Facebook SDK versions)
    // ApplicationDelegate.shared.application(
    //   application,
    //   didFinishLaunchingWithOptions: launchOptions
    // )
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Set notification center delegate for iOS 10+
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle URL opening for Facebook login and sharing (Updated API)
  // override func application(
  //   _ app: UIApplication,
  //   open url: URL,
  //   options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  // ) -> Bool {
  //   // Updated Facebook SDK API call
  //   let handled = ApplicationDelegate.shared.application(
  //     app,
  //     open: url,
  //     options: options
  //   )
    
  //   if handled {
  //     return true
  //   }
    
  //   // If Facebook SDK did not handle the URL, let Flutter handle it.
  //   return super.application(app, open: url, options: options)
  // }
}