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
    _writeJson(req.response, body);
  } else if (path == '/manga') {
    // Manga search — return two fake results.
    final body = jsonEncode({
      'result': 'ok',
      'response': 'collection',
      'data': [
        _fakeMangaItem('mock-manga-1', 'Mock Manga One'),
        _fakeMangaItem('mock-manga-2', 'Mock Manga Two'),
      ],
      'limit': 20,
      'offset': 0,
      'total': 2,
    });
    _writeJson(req.response, body);
  } else if (path.startsWith('/manga/') && path.endsWith('/feed')) {
    // Chapter feed — return two fake chapters in English.
    final mangaId = path.split('/')[2];
    final body = jsonEncode({
      'result': 'ok',
      'response': 'collection',
      'data': [
        {
          'id': 'test-chapter-1',
          'type': 'chapter',
          'attributes': {
            'volume': '1',
            'chapter': '1',
            'title': 'The First Chapter',
            'translatedLanguage': 'en',
            'publishAt': '2020-01-01T00:00:00+00:00',
            'pages': 2,
          },
          'relationships': [
            {
              'id': 'group-1',
              'type': 'scanlation_group',
              'attributes': {'name': 'Mock Scanlations'},
            }
          ],
        },
        {
          'id': 'test-chapter-2',
          'type': 'chapter',
          'attributes': {
            'volume': '1',
            'chapter': '2',
            'title': 'The Second Chapter',
            'translatedLanguage': 'en',
            'publishAt': '2020-02-01T00:00:00+00:00',
            'pages': 2,
          },
          'relationships': [
            {
              'id': 'group-1',
              'type': 'scanlation_group',
              'attributes': {'name': 'Mock Scanlations'},
            }
          ],
        },
      ],
      'limit': 500,
      'offset': 0,
      'total': 2,
      // Provide mangaId in response context so tests can assert on it.
      '_mangaId': mangaId,
    });
    _writeJson(req.response, body);
  } else if (path.startsWith('/manga/') && !path.contains('/feed')) {
    // Manga detail — return fake manga metadata.
    final mangaId = path.split('/')[2];
    final body = jsonEncode({
      'result': 'ok',
      'response': 'entity',
      'data': {
        'id': mangaId,
        'type': 'manga',
        'attributes': {
          'title': {'en': 'Mock Manga Title'},
          'description': {
            'en': 'A fake manga description for integration tests.'
          },
          'status': 'ongoing',
        },
        'relationships': [
          {
            'id': 'cover-art-1',
            'type': 'cover_art',
            'attributes': {'fileName': 'test-cover.jpg'},
          }
        ],
      },
    });
    _writeJson(req.response, body);
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

void _writeJson(HttpResponse response, String body) {
  response
    ..statusCode = HttpStatus.ok
    ..headers
        .set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8')
    ..write(body);
}

Map<String, dynamic> _fakeMangaItem(String id, String title) => {
      'id': id,
      'type': 'manga',
      'attributes': {
        'title': {'en': title},
        'description': {'en': 'A fake manga description.'},
        'status': 'ongoing',
      },
      'relationships': [
        {
          'id': 'cover-art-$id',
          'type': 'cover_art',
          'attributes': {'fileName': 'test-cover.jpg'},
        }
      ],
    };
