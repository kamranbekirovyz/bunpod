import 'package:bunpod/bunpod.dart';

extension ViewStateX<T> on ViewState<T> {
  bool get isIdle => this is ViewIdle<T>;
  bool get isBusy => this is ViewBusy<T>;
  bool get isReady => this is ViewReady<T>;
  bool get isFailed => this is ViewFailed<T>;

  T? get data => this is ViewReady<T> ? (this as ViewReady<T>).data : null;
  T get requireData => (this as ViewReady<T>).data!;
}
