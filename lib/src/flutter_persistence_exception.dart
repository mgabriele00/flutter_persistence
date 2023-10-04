/// Base exception class for all exceptions related to Flutter Persistence.
class FlutterPersistentException implements Exception {
  /// A message describing the exception.
  final String message;

  /// Creates an instance of [FlutterPersistentException] with the specified [message].
  FlutterPersistentException(this.message);

  /// Returns a string representation of the exception.
  @override
  String toString() {
    return 'FlutterPersistentException: $message';
  }
}

/// Exception thrown when an invalid data type is encountered in Flutter Persistence.
class NotAllowedTypeException extends FlutterPersistentException {
  /// Creates an instance of [NotAllowedTypeException].
  NotAllowedTypeException() : super('Not Allowed Type\nAllowed types are: Map<String, dynamic>, Map<dynamic, dynamic>, List<dynamic>, List<int>, List<double>, List<String>, int, double, String\nPS: Also dynamic data must be of an allowed type');
}

/// Exception thrown when an invalid dynamic data type is encountered in Flutter Persistence.
class NotAllowedDynamicTypeException extends FlutterPersistentException {
  /// Creates an instance of [NotAllowedDynamicTypeException].
  NotAllowedDynamicTypeException() : super('Not Allowed Dynamic Type\ndynamic data must be one of the following: Map<String, dynamic>, Map<dynamic, dynamic>, List<dynamic>, List<int>, List<double>, List<String>, int, double, String');
}

/// Exception thrown when an operation is performed without initializing Flutter Persistence.
class NotInitializedException extends FlutterPersistentException {
  /// The optional box name that was not initialized.
  final String? boxName;

  /// Creates an instance of [NotInitializedException] with an optional [boxName].
  NotInitializedException(this.boxName)
      : super('Did you forget to call FlutterPersistence.init(${boxName ?? ""})');
}

/// Exception thrown when a key is not found in the cache.
class NotExistingKey extends FlutterPersistentException {
  /// Creates an instance of [NotExistingKey].
  NotExistingKey() : super("This key is not present in cache");
}
