import Flutter
import UIKit

public class AcringsNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = ACRingsNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId:"activity_rings")
  }
}
