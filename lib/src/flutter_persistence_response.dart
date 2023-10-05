/// Enumeration representing possible response types for the [FlutterPersistenceResponse] class.
enum FlutterPersistenceResponseType {
  /// Indicates that the response has been cached.
  cached,

  /// Indicates that the response has been updated.
  updated,

  /// Indicates that the response is waiting for the first response since data is not cached.
  waiting
}

/// Represents a generic response used to return data in response to persistence operations
/// with [FlutterPersistence].
///
/// The [response] contains the value of the returned data, while [type] specifies
/// the type of response, which can be one of the values enumerated in [FlutterPersistenceResponseType].
class FlutterPersistenceResponse<T> {
  /// The value of the generic response.
  final T? response;

  /// The type of response, one of the values enumerated in [FlutterPersistenceResponseType].
  final FlutterPersistenceResponseType type;

  /// Creates a new instance of [FlutterPersistenceResponse] with the specified data.
  ///
  /// [response] contains the value of the returned data.
  /// [type] specifies the response type.
  const FlutterPersistenceResponse(
      {required this.response, required this.type});

  /// Returns a string representation of the [FlutterPersistenceResponse] object.
  ///
  /// This representation includes the type and value of the response.
  @override
  String toString() {
    return "FlutterPersistenceResponse: type: $type, response: $response";
  }
}
