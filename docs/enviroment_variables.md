# Environment Variable Management — Restock Mobile (Flutter)

## Overview

The Flutter app needs to point to different backend URLs depending on the environment:

- **Local development**: `localhost` (via emulator-specific addresses)
- **CI/CD builds (Firebase App Distribution)**: the deployed Azure backend

This is handled using Flutter's `--dart-define` / `--dart-define-from-file` mechanism, which injects values at **compile time** rather than hardcoding them.

---

## 1. Application Code

`lib/core/constants/api_constants.dart`

```dart
import 'dart:io';

class ApiConstants {
  /// Injected at build time via --dart-define or --dart-define-from-file.
  /// Empty by default for local development.
  static const String _prodUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_prodUrl.isNotEmpty) {
      return _prodUrl;
    }

    // Local development fallback
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/v1/';
    }
    return 'http://127.0.0.1:8080/api/v1/';
  }
}
```

`String.fromEnvironment` only reads values passed at build time — it cannot read `.env` files directly. The `--dart-define-from-file` flag bridges that gap for local development.

---

## 2. Local Development

### Setup
Create a `.env.json` file at the project root (same level as `pubspec.yaml`):

```json
{
  "API_BASE_URL": ""
}
```

This file is **gitignored** and never committed.

### Usage

| Scenario | Command | Result |
|---|---|---|
| Local backend | `flutter run` | Falls back to `localhost` automatically |
| Testing against deployed backend | `flutter run --dart-define-from-file=.env.json` (with `API_BASE_URL` filled in) | Uses the deployed URL |

---

## 3. CI/CD (GitHub Actions)

### Step 1 — Add the secret
`Settings → Secrets and variables → Actions → New repository secret`

| Name | Value |
|---|---|
| `API_BASE_URL` | `https://restock-api-17757.azurewebsites.net/api/v1/` |

### Step 2 — Pass it during build

```yaml
- name: Build release APK
  env:
    API_BASE_URL: ${{ secrets.API_BASE_URL }}
  run: |
    if [ -z "$API_BASE_URL" ]; then
      echo "Missing API_BASE_URL repository secret."
      exit 1
    fi

    flutter build apk --release \
      --dart-define=API_BASE_URL="$API_BASE_URL"
```

The explicit check ensures the build **fails loudly** instead of silently shipping an APK that points to `localhost`.

---

## 4. Summary Table

| Context | Mechanism | Source of `API_BASE_URL` |
|---|---|---|
| Local dev, local backend | none | empty → fallback to `localhost` |
| Local dev, testing deployed backend | `--dart-define-from-file=.env.json` | `.env.json` (gitignored) |
| CI/CD (GitHub Actions) | `--dart-define=API_BASE_URL=...` | GitHub repository secret |

---

## 5. Key Principles

- **Never hardcode** environment-specific URLs in source code.
- **Never commit** `.env.json` — it stays local and gitignored.
- **Compile-time injection**, not runtime config — values are baked into the binary at build time via `--dart-define`.
- **Fail fast in CI** — missing secrets should stop the build, not produce a broken release silently.