import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionExpiryProvider = Provider<SessionExpiry>((ref) {
  final sessionExpiry = SessionExpiry();
  ref.onDispose(sessionExpiry.dispose);
  return sessionExpiry;
});

class SessionExpiry {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get stream => _controller.stream;

  void notify() {
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }

  void dispose() {
    _controller.close();
  }
}

