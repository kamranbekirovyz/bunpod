# expressive_refresh_indicator

Material 3 Expressive pull-to-refresh: Flutter's `RefreshIndicator` drag/arm/snap mechanics with the expressive shape-morphing `LoadingIndicator` (contained) as the spinner.

```dart
ExpressiveRefreshIndicator(
  onRefresh: () async => fetch(),
  child: ListView(...),
)
```

Adapted from the Flutter framework's `RefreshIndicator` (BSD 3-Clause, see LICENSE). Reuses `RefreshCallback`, `RefreshIndicatorStatus`, and `RefreshIndicatorTriggerMode` from `package:flutter/material.dart`.
