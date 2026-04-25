/// Host-side runner for integration tests.
///
/// This script:
///   1. Starts tool/mock_server/main.dart in the background
///   2. Reads the port it prints to stdout
///   3. Runs `flutter test integration_test/` with --dart-define=MOCK_BASE_URL
///      pointing at the mock server so the app never calls the real MangaDex API
///   4. Kills the server when done
///
/// Usage:
///   dart run tool/run_integration_tests.dart [options]
///
/// Options:
///   --host-ip=<ip>       IP the device uses to reach this machine.
///                        Default: 10.0.2.2 (Android emulator → host).
///                        Use your WiFi IP for a real device.
///   --device=<id>        Flutter device ID.  Default: emulator-5554.
///
/// Examples:
///   dart run tool/run_integration_tests.dart
///   dart run tool/run_integration_tests.dart --host-ip=192.168.1.42 --device=R3CN90TXXXX

import 'dart:async';
import 'dart:io';

void main(List<String> args) async {
  var hostIp = '10.0.2.2';
  var device = 'emulator-5554';

  for (final arg in args) {
    if (arg.startsWith('--host-ip=')) {
      hostIp = arg.substring('--host-ip='.length);
    }
    if (arg.startsWith('--device=')) {
      device = arg.substring('--device='.length);
    }
  }

  // ── 1. Start the mock server ──────────────────────────────────────────────
  _log('Starting mock server (host IP for device: $hostIp)…');

  final serverProcess = await Process.start(
    Platform.executable, // dart
    ['run', 'tool/mock_server/main.dart', '0', hostIp],
    workingDirectory: Directory.current.path,
  );

  // Forward server's stderr so we see its request logs.
  serverProcess.stderr.listen((data) => stderr.add(data));

  // Read the port from the server's first stdout line ("PORT=XXXX").
  final portCompleter = Completer<int>();
  serverProcess.stdout.listen((data) {
    final line = String.fromCharCodes(data).trim();
    if (line.startsWith('PORT=') && !portCompleter.isCompleted) {
      portCompleter.complete(int.parse(line.substring('PORT='.length)));
    }
  });

  final port = await portCompleter.future.timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      serverProcess.kill();
      throw Exception('Mock server did not start within 10 seconds.');
    },
  );

  final mockBaseUrl = 'http://$hostIp:$port';
  _log('Mock server is up on port $port. App will use: $mockBaseUrl');

  // ── 2. Run integration tests ──────────────────────────────────────────────
  _log('Running integration tests: flutter test integration_test/ -d $device');

  final testProcess = await Process.start(
    'flutter',
    [
      'test',
      'integration_test/',
      '--dart-define=MOCK_BASE_URL=$mockBaseUrl',
      '-d',
      device,
    ],
    workingDirectory: Directory.current.path,
  );

  // Stream test output in real time.
  testProcess.stdout.listen((data) => stdout.add(data));
  testProcess.stderr.listen((data) => stderr.add(data));

  final exitCode = await testProcess.exitCode;

  // ── 3. Tear down the mock server ─────────────────────────────────────────
  serverProcess.kill();
  _log('Mock server stopped.');

  exit(exitCode);
}

void _log(String msg) => stderr.writeln('[runner] $msg');
