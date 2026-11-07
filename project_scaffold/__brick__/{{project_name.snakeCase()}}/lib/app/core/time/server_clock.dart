class ServerClock {
  ServerClock._();
  static final ServerClock instance = ServerClock._();

  Duration _offset = Duration.zero;

  void syncWithServer(DateTime serverTime) {
    _offset = serverTime.difference(DateTime.now());
  }

  DateTime now() => DateTime.now().add(_offset);
}

