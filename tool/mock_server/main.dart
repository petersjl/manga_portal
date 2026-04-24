/// Standalone MangaDex API mock server for integration testing.
///
/// Handles the subset of the MangaDex API used by the app:
///   GET  /at-home/server/:chapterId  — returns a fake at-home server response
///                                      with baseUrl pointing back at itself
///   POST /report                     — silently accepts MD@Home reports
///   *    (anything else)             — serves an image from tool/mock_server/page_images/
///                                      matched by filename; falls back to the first image
///
/// Usage:
///   dart run tool/mock_server/main.dart [port] [hostIp]
///
/// Arguments:
///   port    — port to listen on; 0 = pick a free port (default)
///   hostIp  — the IP address the device uses to reach this machine
///               Android emulator: 10.0.2.2 (default)
///               Real device on LAN: your machine's WiFi IP
///
/// On startup, prints a single line to stdout:
///   PORT=<port>
/// so the parent process can read it and pass it to `flutter test`.

import 'dart:convert';
import 'dart:io';

/// Directory containing sample page images served for image requests.
final _imageDir = Directory(
  '${File(Platform.script.toFilePath()).parent.path}/page_images',
);

/// Resolves an image file by filename, falling back to the first file found.
File _resolveImage(String filename) {
  final candidate = File('${_imageDir.path}/$filename');
  if (candidate.existsSync()) return candidate;
  final files = _imageDir.listSync().whereType<File>().toList();
  if (files.isEmpty) throw StateError('No images found in ${_imageDir.path}');
  return files.first;
}

String _contentTypeFor(File file) {
  final ext = file.path.split('.').last.toLowerCase();
  return switch (ext) {
    'jpg' || 'jpeg' => 'image/jpeg',
    'png' => 'image/png',
    'gif' => 'image/gif',
    'webp' => 'image/webp',
    _ => 'application/octet-stream',
  };
}

void main(List<String> args) async {
  final port = args.isNotEmpty ? (int.tryParse(args[0]) ?? 0) : 0;
  final hostIp = args.length > 1 ? args[1] : '10.0.2.2';

  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);

  // This line is read by run_integration_tests.dart to learn the port.
  stdout.writeln('PORT=${server.port}');
  await stdout.flush();

  stderr.writeln(
    '[mock-server] Listening on 0.0.0.0:${server.port} '
    '(device accesses via $hostIp:${server.port})',
  );

  await for (final request in server) {
    _handle(request, server.port, hostIp);
  }
}

Future<void> _handle(HttpRequest req, int port, String hostIp) async {
  final path = req.uri.path;
  stderr.writeln('[mock-server] ${req.method} $path');

  if (path.startsWith('/at-home/server/')) {
    // Return a fake at-home server response.
    // baseUrl points back at this server so all image requests come here too.
    final body = jsonEncode({
      'result': 'ok',
      'baseUrl': 'http://$hostIp:$port',
      'chapter': {
        'hash': 'testhash',
        'data': ['page1.jpg', 'page2.jpg'],
        'dataSaver': ['page1.jpg', 'page2.jpg'],
      },
    });
    req.response
      ..statusCode = HttpStatus.ok
      ..headers
          .set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8')
      ..write(body);
  } else {
    // All other paths — image downloads, the /report POST, etc.
    // Serve an image from page_images/, matched by filename.
    final filename = path.split('/').last;
    final imageFile = _resolveImage(filename);
    final bytes = await imageFile.readAsBytes();
    req.response
      ..statusCode = HttpStatus.ok
      ..headers.set(HttpHeaders.contentTypeHeader, _contentTypeFor(imageFile))
      ..headers.set(HttpHeaders.contentLengthHeader, bytes.length)
      ..add(bytes);
  }

  await req.response.close();
}
