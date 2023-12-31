/*
 * Copyright 2020. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agconnect_remote_config/agconnect_remote_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('mock test', () {
    const MethodChannel channel =
        MethodChannel('com.huawei.flutter/agconnect_remote_config');
    MethodCall? mockCall;
    setUp(() {
      // TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (methodCall) async {
        mockCall = methodCall;
        switch (methodCall.method) {
          case 'applyDefaults':
            return null;
          case 'applyLastFetched':
            return null;
          case 'fetch':
            return null;
          case 'getValue':
            return 'test_value';
          case 'getMergedAll':
            return {'key1': 'value1'};
          case 'clearAll':
            return null;
          case 'getSource':
            return 2;
          case 'setDeveloperMode':
            return null;
        }
        throw PlatformException(
            code: '0', message: 'Unknown method call, please update test.');
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (message) => null);
    });

    test('applyDefaults', () async {
      await AGCRemoteConfig.instance.applyDefaults({
        'key1': 'value1',
        'key2': true,
        'key3': 3,
        'key4': 3.14,
        'key5': null
      });
      expect(mockCall?.method, 'applyDefaults');
      expect(mockCall?.arguments, {
        'defaults': {
          'key1': 'value1',
          'key2': 'true',
          'key3': '3',
          'key4': '3.14',
          'key5': 'null'
        }
      });
    });

    test('applyDefaults null', () async {
      await AGCRemoteConfig.instance.applyDefaults(null);
      expect(mockCall?.method, 'applyDefaults');
      expect(mockCall?.arguments, {'defaults': {}});
    });

    test('applyLastFetched', () async {
      await AGCRemoteConfig.instance.applyLastFetched();
      expect(mockCall?.method, 'applyLastFetched');
      expect(mockCall?.arguments, null);
    });

    test('getValue', () async {
      String? value = await AGCRemoteConfig.instance.getValue('test_key');
      expect(mockCall?.method, 'getValue');
      expect(mockCall?.arguments, {'key': 'test_key'});
      expect(value, 'test_value');
    });

    test('getMergedAll', () async {
      final value = await AGCRemoteConfig.instance.getMergedAll();
      expect(mockCall?.method, 'getMergedAll');
      expect(mockCall?.arguments, null);
      expect(value, {'key1': 'value1'});
    });

    test('clearAll', () async {
      await AGCRemoteConfig.instance.clearAll();
      expect(mockCall?.method, 'clearAll');
      expect(mockCall?.arguments, null);
    });

    test('getSource', () async {
      RemoteConfigSource? value =
          await AGCRemoteConfig.instance.getSource('test_key');
      expect(mockCall?.method, 'getSource');
      expect(mockCall?.arguments, {'key': 'test_key'});
      expect(value, RemoteConfigSource.remote);
    });

    test('setDeveloperMode', () async {
      await AGCRemoteConfig.instance.setDeveloperMode(true);
      expect(mockCall?.method, 'setDeveloperMode');
      expect(mockCall?.arguments, {'mode': true});
    });
  });
}
