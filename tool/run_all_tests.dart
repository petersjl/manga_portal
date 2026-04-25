/// Runs the full test suite: widget tests + integration tests.
///
/// Starts the mock server, runs widget tests first, then integration tests
/// against the mock server. Stops the server when done.
///
/// Usage:
///   dart run tool/run_all_tests.dart [options]
///
/// Options:
///   --host-ip=<ip>       IP the device uses to reach this machine.
///                        Default: 10.0.2.2 (Android emulator → host).
///                        Use your WiFi IP for a real device.
///   --device=<id>        Flutter device ID. Default: emulator-5554.

import 'dart:async';
import 'dart:io';

void main(List<String> args) async {
  var hostIp = '10.0.2.2';
  var device = 'emulator-5554';

  for (final arg in args) {
    if (arg.startsWith('--host-ip='))
      hostIp = arg.substring('--host-ip='.length);
    if (arg.startsWith('--device=')) device = arg.substring('--device='.length);
  }

  // ── 1. Start the mock server ──────────────────────────────────────────────
  _log('Starting mock server…');

  final serverProcess = await Process.start(
    Platform.executable,
    ['run', 'tool/mock_server/main.dart', '0', hostIp],
    workingDirectory: Directory.current.path,
  );

  serverProcess.stderr.listen((data) => stderr.add(data));

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
  _log('Mock server up on port $port.');

  // ── 2. Widget tests (no server needed, but server is already running) ─────
  _log('Running widget tests…');
  final widgetCode = await _run(['flutter', 'test', 'test/']);
  if (widgetCode != 0) {
    serverProcess.kill();
    _log('Widget tests failed.');
    exit(widgetCode);
  }

  // ── 3. Integration tests ──────────────────────────────────────────────────
  _log('Running integration tests against mock server…');
  final integrationCode = await _run([
    'flutter',
    'test',
    'integration_test/',
    '--dart-define=MOCK_BASE_URL=$mockBaseUrl',
    '-d',
    device,
  ]);

  // ── 4. Tear down ──────────────────────────────────────────────────────────
  serverProcess.kill();
  _log('Mock server stopped.');

  exit(integrationCode);
}

Future<int> _run(List<String> cmd) async {
  final process = await Process.start(
    cmd.first,
    cmd.skip(1).toList(),
    workingDirectory: Directory.current.path,
  );
  process.stdout.listen((data) => stdout.add(data));
  process.stderr.listen((data) => stderr.add(data));
  return process.exitCode;
}

void _log(String msg) => stderr.writeln('[runner] $msg');
