# Development

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer

## Run it

1. Copy `local.example.json` to `local.json`. It's gitignored, so your keys stay on your machine.
2. Get a free API key and secret at [api.podcastindex.org](https://api.podcastindex.org) and add them to `local.json`.
3. Create a Firebase project with iOS and Android apps, then fill in the `FIREBASE_` values. The app needs them to start.
4. Optionally, add the `USERORIENT_` and `TELEGRAM_` values. They power the feedback board and launch failure reports.
5. Run the app:

```bash
flutter run --dart-define-from-file=local.json
```
