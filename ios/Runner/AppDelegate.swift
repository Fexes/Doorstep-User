import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices .provideAPIKey("AIzaSyD_U_2NzdPIL7TWb8ECBHWO1eROR2yrebI")
    

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
