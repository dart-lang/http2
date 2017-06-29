// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:test/test.dart';

import 'package:http2/src/frames/frames.dart';
import 'package:http2/src/hpack/hpack.dart';
import 'package:http2/src/settings/settings.dart';

import '../error_matchers.dart';
import '../mock_utils.dart';

main() {
  group('settings-handler', () {
    var pushSettings = [new Setting(Setting.SETTINGS_ENABLE_PUSH, 0)];
    var invalidPushSettings = [new Setting(Setting.SETTINGS_ENABLE_PUSH, 2)];
    var setMaxTable256 = [new Setting(Setting.SETTINGS_HEADER_TABLE_SIZE, 256)];

    test('successful-setting', () async {
      var writer = new FrameWriterMock();
      var sh = new SettingsHandler(
          new HPackEncoder(), writer,
          new ActiveSettings(), new ActiveSettings());
      var tc = new TestCounter();

      writer.mock_writeSettingsFrame = (List<Setting> s, {bool ack: false}) {
        expect(s, pushSettings);
        expect(ack, false);
        tc.got();
      };

      // Start changing settings.
      Future changed = sh.changeSettings(pushSettings);

      // Check that settings haven't been applied.
      expect(sh.acknowledgedSettings.enablePush, true);

      // Simulate remote end to responsd with an ACK.
      var header = new FrameHeader(
          0, FrameType.SETTINGS, SettingsFrame.FLAG_ACK, 0);
      sh.handleSettingsFrame(new SettingsFrame(header, []));

      await changed;

      // Check that settings have been applied.
      expect(sh.acknowledgedSettings.enablePush, false);
    });

    test('ack-remote-settings-change', () {
      var writer = new FrameWriterMock();
      var sh = new SettingsHandler(
          new HPackEncoder(), writer,
          new ActiveSettings(), new ActiveSettings());
      var tc = new TestCounter();

      writer.mock_writeSettingsAckFrame = () {
        tc.got();
      };

      // Check that settings haven't been applied.
      expect(sh.peerSettings.enablePush, true);

      // Simulate remote end by setting the push setting.
      var header = new FrameHeader(6, FrameType.SETTINGS, 0, 0);
      sh.handleSettingsFrame(new SettingsFrame(header, pushSettings));

      // Check that settings have been applied.
      expect(sh.peerSettings.enablePush, false);
    });

    test('invalid-remote-ack', () {
      var writer = new FrameWriterMock();
      var sh = new SettingsHandler(
          new HPackEncoder(), writer,
          new ActiveSettings(), new ActiveSettings());

      // Simulates ACK even though we haven't sent any settings.
      var header = new FrameHeader(
          0, FrameType.SETTINGS, SettingsFrame.FLAG_ACK, 0);
      var settingsFrame = new SettingsFrame(header, const []);

      expect(() => sh.handleSettingsFrame(settingsFrame),
             throwsA(isProtocolException));
    });

    test('invalid-remote-settings-change', () {
      var writer = new FrameWriterMock();
      var sh = new SettingsHandler(
          new HPackEncoder(), writer,
          new ActiveSettings(), new ActiveSettings());

      // Check that settings haven't been applied.
      expect(sh.peerSettings.enablePush, true);

      // Simulate remote end by setting the push setting.
      var header = new FrameHeader(6, FrameType.SETTINGS, 0, 0);
      var settingsFrame = new SettingsFrame(header, invalidPushSettings);
      expect(() => sh.handleSettingsFrame(settingsFrame),
             throwsA(isProtocolException));
    });

    test('change-max-header-table-size', () {
      var writer = new FrameWriterMock();
      var mock = new HPackEncoderMock();
      var sh = new SettingsHandler(
          mock, writer,
          new ActiveSettings(), new ActiveSettings());

      // Simulate remote end by setting the push setting.
      var header = new FrameHeader(6, FrameType.SETTINGS, 0, 0);
      var settingsFrame = new SettingsFrame(header, setMaxTable256);
      mock.mock_updateMaxSendingHeaderTableSize = expectAsync1((int newSize) {
        expect(newSize, 256);
      });
      writer.mock_writeSettingsAckFrame = expectAsync0(() { });
      sh.handleSettingsFrame(settingsFrame);
    });
  });
}

class FrameWriterMock extends SmartMock implements FrameWriter { }

class HPackEncoderMock extends SmartMock implements HPackEncoder { }
