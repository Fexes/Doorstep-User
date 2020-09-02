import UIKit
import Flutter
import Firebase;
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices .provideAPIKey("AIzaSyBoLgH-s1XnyhCQ2PZEUbIaH_Jj2RKhMSU")


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
