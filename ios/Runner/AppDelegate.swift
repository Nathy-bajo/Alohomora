import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override
func application(_ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions:
                 [UIApplication.LaunchOptionsKey: Any]?
                 ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      // UIApplication.shared.didRegisterForRemoteNotificationsWithDeviceToken()
    
     if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
    if let error = error {
        print("D'oh: \(error.localizedDescription)")
    } 
    // else {
    //     application.didRegisterForRemoteNotificationsWithDeviceToken()
    // }

}
}

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let tokenChannel = FlutterMethodChannel(name: "samples.flutter.dev/device_token",
                                              binaryMessenger: controller.binaryMessenger)
    tokenChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
    // This method is invoked on the UI thread.
    guard call.method == "getDeviceToken" else {
    result(FlutterMethodNotImplemented)
    return
  }
  self?.getDeviceToken(result: result)
    })


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ application: UIApplication,
            didRegisterForRemoteNotificationsWithDeviceToken 
                deviceToken: Data) {
                   let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
                  UserDefaults.standard.set(token, forKey: "deviceToken") 
                  print("Remote TokenParts: \(token)")

}

    override func application(_ application: UIApplication,
            didFailToRegisterForRemoteNotificationsWithError 
                error: Error) {
                      print("Failed to register for notifications: \(error.localizedDescription)")

}

private func getDeviceToken(result: FlutterResult) {
    let token = UserDefaults.standard.string(forKey: "deviceToken")
    print("Device Token: \(String(describing: token))")

   result(token)
}

}




// import UIKit
// import Flutter

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override

//     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//     let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert,UIUserNotificationType.badge, UIUserNotificationType.sound]
//     let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)

//     application.registerUserNotificationSettings(pushNotificationSettings)
//     application.registerForRemoteNotifications()

//     // return true    

//      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//     let tokenChannel = FlutterMethodChannel(name: "samples.flutter.dev/device_token",
//                                               binaryMessenger: controller.binaryMessenger)
//     tokenChannel.setMethodCallHandler({
//       [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
//     // This method is invoked on the UI thread.
//     guard call.method == "getDeviceToken" else {
//     result(FlutterMethodNotImplemented)
//     return
//   }
//   // self?.getDeviceToken(result: result)
//     })


//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)    
// }

// override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

//     let tokenParts = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//     // let token = tokenParts.joined()
//     //               UserDefaults.standard.set(token, forKey: "deviceToken") 

//                   print("Remote Tokens: \(tokenParts)")
//                   // print("Device Token: \(token)")
// }

// override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

//     print("i am not available in simulator \(error)")
// }
// }

