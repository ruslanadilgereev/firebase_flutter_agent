import 'package:flutter_test/flutter_test.dart';
import 'package:acrings_native/acrings_native.dart';
import 'package:acrings_native/acrings_native_platform_interface.dart';
import 'package:acrings_native/acrings_native_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAcringsNativePlatform
    with MockPlatformInterfaceMixin
    implements AcringsNativePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AcringsNativePlatform initialPlatform = AcringsNativePlatform.instance;

  test('$MethodChannelAcringsNative is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAcringsNative>());
  });

  test('getPlatformVersion', () async {
    AcringsNative acringsNativePlugin = AcringsNative();
    MockAcringsNativePlatform fakePlatform = MockAcringsNativePlatform();
    AcringsNativePlatform.instance = fakePlatform;

    expect(await acringsNativePlugin.getPlatformVersion(), '42');
  });
}
