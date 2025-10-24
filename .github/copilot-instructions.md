# FluttCloud AI Coding Instructions

As a senior Flutter/Dart developer working on this Serverpod project, here are the essential patterns and architecture details for FluttCloud.

## Project Architecture

**Three-Layer Serverpod Structure:**

- `fluttcloud_server/` - Backend API server with file management endpoints
- `fluttcloud_client/` - Auto-generated client SDK (don't modify manually)
- `fluttcloud_flutter/` - Flutter frontend app with dependency injection

**Key Directories:**

- `fluttcloud_server/lib/src/models/` - YAML model definitions (source of truth for data models)
- `fluttcloud_server/lib/src/endpoinds/` - API endpoints (note the typo in folder name)
- `fluttcloud_server/lib/src/generated/` - Auto-generated protocol files from models
- `fluttcloud_flutter/lib/src/core/` - App initialization, routing, DI
- `fluttcloud_flutter/lib/src/features/` - Feature-based UI organization

## Core Development Patterns

**Server Endpoints** follow this structure:

```dart
class FilesEndpoint extends Endpoint {
  Future<Result> method(Session session, params) async {
    await _validateAccess(session); // Admin-only access pattern
    // Implementation
  }
}
```

**Authentication** uses Serverpod Auth with admin-first-user pattern:

- First registered user becomes admin automatically
- Registration disabled after first user unless `ALLOW_REGISTRATION=1`
- Custom exceptions: `UnAuthorizedException`, `UserNotFoundException`, `NotFoundException`

**Flutter DI** uses injectable/get_it pattern:

```dart
@singleton
class MyService {
  static MyService get I => getIt<MyService>();
}
```

**Flutter State** managed with ChangeNotifier controllers, not BLoC or Riverpod.

**UI Architecture Rules:**

- **NO ScaffoldMessenger**: Always use `await ToastController.I.show(message, type: ToastType.error/success/info)` instead of ScaffoldMessenger.of(context).showSnackBar
- **NO Direct API Calls in UI**: Never use `Serverpod.I.client.*` in UI components. Create dedicated controllers with injectable pattern and use them instead
- **Controller Pattern**: UI widgets should only call controller methods, controllers handle all business logic and API calls

## Essential Development Workflows

**Data Models - ALWAYS use YAML:**

- Create/modify models in `fluttcloud_server/lib/src/models/*.spy.yaml`
- Use Serverpod YAML syntax: `class:`, `enum:`, `fields:`, `values:`
- Example: `fs_entry.spy.yaml` defines FsEntry with typed fields
- **User IDs**: Always use `int, relation(parent=serverpod_user_info, onDelete=Cascade)` for user ID fields

**Code Generation (crucial):**

```bash
# Option 1: Use convenience script (recommended)
./scripts/generate.sh all  # Generate both server and flutter
./scripts/generate.sh server  # Server only
./scripts/generate.sh flutter  # Flutter only

# Option 2: Manual commands
# Server: Generate protocol after model/endpoint changes
cd fluttcloud_server && puro dart pub -v global run serverpod_cli:serverpod_cli generate

# Flutter: Generate files after model changes
cd fluttcloud_flutter && make pre_build
```

**Database Operations:**

- Migration files auto-generated in `migrations/`
- Use `docker compose up --build --detach` for local dev DB
- Test DB on different ports (9090/9091)

**Testing Pattern:**

```dart
withServerpod('Test description', (sessionBuilder, endpoints) {
  test('specific test', () async {
    final result = await endpoints.files.method(sessionBuilder, params);
    expect(result, expected);
  });
});
```

## Critical Configuration

**Environment Variables:**

- `FILES_DIRECTORY_PATH` - File storage location (default: `/data`)
- `PRIVATE_SHARE_LINK_PREFIX` - File sharing URL prefix (default: `/share/root`)
- `ALLOW_REGISTRATION` - Enable user registration beyond first admin

**File Serving** has two modes:

- `RawFileServer` - Public access
- `AuthenticatedFileServer` - Admin-only access

**Flutter App Init** sequence:

1. `AppInit.init()` - Core setup, localization, dependencies
2. `AppInit.buildInit()` - Runtime initialization
3. Server connection via `getIt<Serverpod>().init(serverUrl)`

## Project-Specific Conventions

- Use `common_imports.dart` for shared imports, not individual imports
- File organization: `lib/src/core/` (shared), `lib/src/features/` (UI features)
- Testing: Integration tests in `test/integration/`, use `withServerpod` helper
- Error handling: Custom exception classes, not generic Exception
- Route guards: `ServerConfigGuard()`, `AuthGuard()` for protected routes
- File uploads: Stream-based with content-type detection via `contentTypeMapping`

## Deployment Ready

- Docker multi-stage builds configured
- AWS/GCP Terraform modules in `deploy/`
- Environment-specific configs: `development.yaml`, `production.yaml`, `staging.yaml`
- Health checks and monitoring built-in via Serverpod Insights

## Do Not Modify

- Any files in `lib/src/generated/` directories (auto-generated from YAML models)
- `migration_registry.txt` (managed by Serverpod)
- Client protocol files (regenerated from server)

**NEVER create Dart model files directly - use YAML models in `lib/src/models/` instead**

## Code Quality Standards

### Analysis & Warnings - ZERO TOLERANCE

**MUST fix ALL analyzer issues including info and warnings:**

```bash
puro flutter analyze --no-congratulate
```

**Common issues to avoid:**

- ❌ `unnecessary_await_in_return` - Remove `await` in simple return statements
- ❌ `unawaited_futures` - Always `await` Future-returning method calls (especially ToastController.I.show)
- ❌ `use_if_null_to_convert_nulls_to_bools` - Use `result ?? false` instead of `result == true`
- ❌ `unnecessary_import` - Remove unused imports, rely on `common_imports.dart`
- ❌ `always_use_package_imports` - Use `package:` imports, not relative paths
- ❌ `deprecated_member_use` - Use `initialValue` instead of `value` for form fields

### Localization Patterns

**Unified Structure** - Avoid duplication:

```json
{
  "expiration": {
    "never": "Never expires",
    "expires_on": "Expires on: {}",
    "expired_on": "Expired on: {}",
    "in_hours": { "one": "Expires in {} hour", "other": "Expires in {} hours" },
    "in_days": { "one": "Expires in {} day", "other": "Expires in {} days" }
  }
}
```

**Usage Patterns:**

```dart
// ✅ Proper plural usage
LocaleKeys.expiration_in_hours.plural(1)   // "Expires in 1 hour"
LocaleKeys.expiration_in_days.plural(7)    // "Expires in 7 days"

// ✅ Centralized keys
LocaleKeys.expiration_never.tr()           // Single source of truth

// ❌ Avoid duplicates
LocaleKeys.share_link_never_expires.tr()
LocaleKeys.share_links_never_expires.tr()  // DON'T duplicate!
```

### Import Organization

**Primary Pattern:**

```dart
import 'package:fluttcloud_client/fluttcloud_client.dart';
import 'package:fluttcloud_flutter/common_imports.dart';
import 'package:flutter/material.dart';
// Avoid individual component imports when already in common_imports
```

**What's in common_imports.dart:**

- All UI components (dialogs, controllers, etc.)
- Localization (LocaleKeys)
- GetIt DI
- Extensions and utilities
- Theme and routing

### Async/Await Standards

**Always await Future calls:**

```dart
// ✅ Correct
await ToastController.I.show(message);
await Clipboard.setData(ClipboardData(text: url));
await Navigator.of(context).pop();

// ❌ Incorrect - causes unawaited_futures warning
ToastController.I.show(message);
```

**Return Futures properly:**

```dart
// ✅ Correct
Future<bool?> show(BuildContext context) {
  return showDialog<bool>(context: context, builder: (context) => this);
}

// ❌ Incorrect - unnecessary await
Future<bool?> show(BuildContext context) async {
  return await showDialog<bool>(context: context, builder: (context) => this);
}
```

### Null Safety Patterns

**Boolean conversion:**

```dart
// ✅ Correct
if (result ?? false) { /* handle */ }

// ❌ Incorrect - triggers analyzer warning
if (result == true) { /* handle */ }
```

### Form Field Updates

**Use modern API:**

```dart
// ✅ Correct
DropdownButtonFormField<int>(
  initialValue: _selectedIndex,
  // ...
)

// ❌ Incorrect - deprecated
DropdownButtonFormField<int>(
  value: _selectedIndex,
  // ...
)
```

## Response Requirements

### Summary Format

**Provide SHORT summary at end of work - format:**

```
✅ Fixed [X] analyzer warnings: [specific issues]
✅ Updated localization: [changes made]
✅ Enhanced [feature]: [key improvements]
```

**DO NOT:**

- Create separate summary files
- Write verbose explanations
- Include code examples in summary
- Create markdown documentation files

**DO:**

- Fix every analyzer issue (including info/warnings)
- Test with `puro flutter analyze --no-congratulate`
- Use proper await patterns
- Follow localization deduplication
- Keep summary concise and actionable
