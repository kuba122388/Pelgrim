class NoInternetException implements Exception {
  final String message;

  NoInternetException([this.message = "Brak połączenia z internetem"]);

  @override
  String toString() => message;
}
