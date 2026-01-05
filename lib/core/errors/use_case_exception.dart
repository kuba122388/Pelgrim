class UseCaseException implements Exception {
  final String message;

  UseCaseException(this.message);

  @override
  String toString() => 'UseCaseException: $message';
}
