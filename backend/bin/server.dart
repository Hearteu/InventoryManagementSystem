import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

late Connection connection;
late DotEnv env;

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/api/parts', _getPartsHandler);

Response _rootHandler(Request req) {
  return Response.ok('IMS Backend API is running.\n');
}

Future<Response> _getPartsHandler(Request request) async {
  try {
    final result = await connection.execute('SELECT * FROM parts;');
    final parts = result.map((row) => row.toColumnMap()).toList();
    return Response.ok(
      jsonEncode(parts),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Database error: $e');
  }
}

void main(List<String> args) async {
  // Load environment variables
  env = DotEnv(includePlatformEnvironment: true)..load();

  // Connect to PostgreSQL
  try {
    connection = await Connection.open(
      Endpoint(
        host: env['DB_HOST'] ?? 'localhost',
        port: int.parse(env['DB_PORT'] ?? '5432'),
        database: env['DB_NAME'] ?? 'postgres',
        username: env['DB_USER'] ?? 'postgres',
        password: env['DB_PASSWORD'] ?? 'password',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    print('Connected to PostgreSQL database.');
  } catch (e) {
    print('Failed to connect to the database: $e');
    exit(1);
  }

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
