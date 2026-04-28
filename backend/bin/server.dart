import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

late Connection connection;
late DotEnv env;
final String jwtSecret = 'super_secret_ims_key_123';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..post('/api/auth/login', _loginHandler)
  ..get('/api/parts', _getPartsHandler)
  ..post('/api/parts', _addPartHandler)
  ..post('/api/stock/movement', _addStockMovementHandler)
  ..get('/api/dashboard/stats', _getDashboardStatsHandler);

Response _rootHandler(Request req) {
  return Response.ok('IMS Backend API is running.\n');
}

// === AUTHENTICATION ===

String _hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<Response> _loginHandler(Request request) async {
  try {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    final email = data['email'];
    final password = data['password'];

    if (email == null || password == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Email and password required'}));
    }

    final result = await connection.execute(
      Sql.named('SELECT * FROM users WHERE email = @email'),
      parameters: {'email': email},
    );

    if (result.isEmpty) {
      return Response.forbidden(jsonEncode({'error': 'Invalid credentials'}));
    }

    final user = result.first.toColumnMap();
    if (user['password_hash'] != _hashPassword(password)) {
      return Response.forbidden(jsonEncode({'error': 'Invalid credentials'}));
    }

    // Generate JWT
    final jwt = JWT({
      'id': user['id'].toString(),
      'email': user['email'],
      'role': user['role'],
    });

    final token = jwt.sign(SecretKey(jwtSecret), expiresIn: const Duration(days: 7));

    return Response.ok(
      jsonEncode({'token': token, 'user': {'email': user['email'], 'role': user['role']}}),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': 'Auth error: $e'}));
  }
}

// === MIDDLEWARE ===

Middleware checkAuth() {
  return (Handler innerHandler) {
    return (Request request) async {
      // Exclude login and root from auth
      if (request.url.path == 'api/auth/login' || request.url.path.isEmpty) {
        return innerHandler(request);
      }

      // Check header
      final authHeader = request.headers['Authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden(jsonEncode({'error': 'Missing or invalid token'}));
      }

      final token = authHeader.substring(7);
      try {
        JWT.verify(token, SecretKey(jwtSecret));
        return innerHandler(request);
      } catch (e) {
        return Response.forbidden(jsonEncode({'error': 'Invalid token'}));
      }
    };
  };
}

// === PARTS API ===

Future<Response> _getPartsHandler(Request request) async {
  try {
    final result = await connection.execute('SELECT * FROM parts ORDER BY updated_at DESC;');
    final parts = result.map((row) => row.toColumnMap()).toList();
    return Response.ok(
      jsonEncode(parts),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': 'Database error: $e'}));
  }
}

Future<Response> _addPartHandler(Request request) async {
  try {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    if (data['name'] == null || data['sku'] == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Name and SKU are required.'}));
    }

    final result = await connection.execute(
      Sql.named('''
        INSERT INTO parts 
        (sku, oem_number, name, category, location, quantity_on_hand, reorder_point, unit_cost, material, weight_kg, dimensions) 
        VALUES 
        (@sku, @oem_number, @name, @category, @location, @quantity_on_hand, @reorder_point, @unit_cost, @material, @weight_kg, @dimensions) 
        RETURNING *
      '''),
      parameters: {
        'sku': data['sku'],
        'oem_number': data['oem_number'],
        'name': data['name'],
        'category': data['category'],
        'location': data['location'],
        'quantity_on_hand': data['quantity_on_hand'] ?? 0,
        'reorder_point': data['reorder_point'] ?? 0,
        'unit_cost': data['unit_cost'] ?? 0.0,
        'material': data['material'],
        'weight_kg': data['weight_kg'],
        'dimensions': data['dimensions'],
      },
    );
    
    final newPart = result.first.toColumnMap();
    return Response.ok(
      jsonEncode(newPart),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': 'Database error: $e'}));
  }
}

// === STOCK MOVEMENT API ===

Future<Response> _addStockMovementHandler(Request request) async {
  try {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    final String partId = data['part_id'];
    final String type = data['transaction_type']; // inbound, outbound, adjustment
    final int qty = data['quantity'];
    final String reason = data['reason'] ?? '';

    // First get current quantity
    final partResult = await connection.execute(
      Sql.named('SELECT quantity_on_hand FROM parts WHERE id = @id::uuid'),
      parameters: {'id': partId},
    );

    if (partResult.isEmpty) {
      return Response.notFound(jsonEncode({'error': 'Part not found'}));
    }

    int currentQty = partResult.first[0] as int;
    int newQty = currentQty;

    if (type == 'inbound') {
      newQty += qty;
    } else if (type == 'outbound') {
      newQty -= qty;
    } else if (type == 'adjustment') {
      newQty = qty; // For adjustment, qty is the new absolute quantity
    }

    int movementQty = type == 'adjustment' ? (newQty - currentQty) : qty;

    // Begin transaction
    await connection.execute('BEGIN');
    
    // Update part
    await connection.execute(
      Sql.named('UPDATE parts SET quantity_on_hand = @new_qty, updated_at = NOW() WHERE id = @id::uuid'),
      parameters: {'new_qty': newQty, 'id': partId},
    );

    // Insert movement
    final movResult = await connection.execute(
      Sql.named('''
        INSERT INTO stock_movements 
        (part_id, transaction_type, quantity, balance_after, reason) 
        VALUES (@part_id::uuid, @type, @qty, @balance, @reason) 
        RETURNING *
      '''),
      parameters: {
        'part_id': partId,
        'type': type,
        'qty': movementQty,
        'balance': newQty,
        'reason': reason,
      },
    );

    await connection.execute('COMMIT');

    return Response.ok(jsonEncode(movResult.first.toColumnMap()), headers: {'content-type': 'application/json'});
  } catch (e) {
    await connection.execute('ROLLBACK');
    return Response.internalServerError(body: jsonEncode({'error': 'Database error: $e'}));
  }
}

// === DASHBOARD API ===

Future<Response> _getDashboardStatsHandler(Request request) async {
  try {
    final partsResult = await connection.execute('SELECT COUNT(*) as total_parts, SUM(quantity_on_hand * unit_cost) as total_value FROM parts');
    final alertsResult = await connection.execute('SELECT COUNT(*) as low_stock FROM parts WHERE quantity_on_hand <= reorder_point');
    final movementsResult = await connection.execute('SELECT COUNT(*) as pending_movements FROM stock_movements WHERE created_at >= NOW() - INTERVAL \'24 HOURS\'');

    final stats = {
      'total_parts': partsResult.first[0] ?? 0,
      'total_value': partsResult.first[1] ?? 0.0,
      'low_stock_alerts': alertsResult.first[0] ?? 0,
      'recent_movements': movementsResult.first[0] ?? 0,
    };

    return Response.ok(jsonEncode(stats), headers: {'content-type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': 'Database error: $e'}));
  }
}

// === DB INIT ===
Future<void> _initDatabase() async {
  print('Running database migrations if needed...');
  try {
    // Create users table
    await connection.execute('''
      CREATE TABLE IF NOT EXISTS users (
          id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
          email VARCHAR(255) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          role VARCHAR(50) DEFAULT 'USER',
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    
    // Create admin user (password: admin123)
    final adminHash = _hashPassword('admin123');
    await connection.execute('''
      INSERT INTO users (email, password_hash, role) 
      VALUES ('admin@ims.com', '$adminHash', 'ADMIN') 
      ON CONFLICT DO NOTHING;
    ''');
    print('Database initialized.');
  } catch (e) {
    print('Error during DB init: $e');
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
    
    await _initDatabase();
  } catch (e) {
    print('Failed to connect to the database: $e');
    exit(1);
  }

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  // Add checkAuth() here if you want to secure the routes globally.
  // For now, we use a middleware but we apply it carefully or handle auth per route.
  // We'll apply it globally via Pipeline!
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(checkAuth())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
