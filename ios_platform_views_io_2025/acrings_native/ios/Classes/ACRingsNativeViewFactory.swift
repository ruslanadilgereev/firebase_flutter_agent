import Flutter
import SwiftUI

class ACRingsNativeViewFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return NativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

  /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
  public func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol) {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class NativeView: NSObject, FlutterPlatformView {
private var _view: UIView
  init(
          frame: CGRect,
          viewIdentifier viewId: Int64,
          arguments args: Any?,
          binaryMessenger messenger: FlutterBinaryMessenger?
      ) {
          _view = UIView()
          super.init()
          // iOS views can be created here
          createNativeView(view: _view)
      }

      func view() -> UIView {
          return _view
      }

      func createNativeView(view _view: UIView){
          let keyWindows = UIApplication.shared.windows.first(where: {$0.isKeyWindow }) ?? UIApplication.shared.windows.first
          let topController = keyWindows?.rootViewController

          let vc = UIHostingController(rootView: ACRings())
          let swiftUIView = vc.view!

          topController!.addChild(vc)
          _view.addSubview(swiftUIView)
      }
}