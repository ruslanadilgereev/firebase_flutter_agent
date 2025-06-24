import FlutterMacOS
import Cocoa

public class AcringsNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "acrings_native", binaryMessenger: registrar.messenger)
    let instance = AcringsNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let factory = ACRingsNativeViewFactory(messenger: registrar.messenger)
    registrar.register(factory, withId:"activity_rings")
  }
}
