import 'package:flutter_test/flutter_test.dart';
import 'package:gen_plugin/gen_plugin.dart';
import 'package:gen_plugin/gen_plugin_platform_interface.dart';
import 'package:gen_plugin/gen_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGenPluginPlatform
    with MockPlatformInterfaceMixin
    implements GenPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GenPluginPlatform initialPlatform = GenPluginPlatform.instance;

  test('$MethodChannelGenPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGenPlugin>());
  });

  test('getPlatformVersion', () async {
    GenPlugin genPlugin = GenPlugin();
    MockGenPluginPlatform fakePlatform = MockGenPluginPlatform();
    GenPluginPlatform.instance = fakePlatform;

    expect(await genPlugin.getPlatformVersion(), '42');
  });
}
