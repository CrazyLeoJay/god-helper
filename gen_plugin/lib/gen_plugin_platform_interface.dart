import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gen_plugin_method_channel.dart';

abstract class GenPluginPlatform extends PlatformInterface {
  /// Constructs a GenPluginPlatform.
  GenPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static GenPluginPlatform _instance = MethodChannelGenPlugin();

  /// The default instance of [GenPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelGenPlugin].
  static GenPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GenPluginPlatform] when
  /// they register themselves.
  static set instance(GenPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
