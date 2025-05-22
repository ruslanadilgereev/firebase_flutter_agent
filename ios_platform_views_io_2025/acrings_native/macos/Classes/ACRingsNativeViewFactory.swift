import Cocoa
import FlutterMacOS
import SwiftUI

class ACRingsNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withViewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> NSView {
        return NativeView(
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class NativeView: NSView {

    init(
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        //wantsLayer = true
        // macOS views can be created here
        createNativeView(view: self)
    }

    required init?(coder nsCoder: NSCoder) {
        super.init(coder: nsCoder)
    }

    func createNativeView(view _view: NSView) {
        let hostingView =  NSHostingView(rootView: ACRings())
        self.addSubview(hostingView)
    }
}
