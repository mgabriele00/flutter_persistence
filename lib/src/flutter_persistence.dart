import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'flutter_persistence_exception.dart';
import 'flutter_persistence_response.dart';

enum _ValidType {
  mapStringDynamic,
  listMapStringDynamic,
  otherValidData,
}

/// An abstract class providing utility methods for persisting and retrieving data
/// using Hive as a local storage solution in Flutter applications.
abstract class FlutterPersistence {
  static const _defaultBoxName = "flutter_persistence";

  /// Initializes Hive for Flutter and opens a storage box for data storage.
  ///
  /// [boxName] is an optional parameter that allows you to specify a custom box name.
  ///
  /// Throws [NotInitializedException] if Hive initialization fails.
  static Future<void> init([String? boxName]) async {
    await Hive.initFlutter();
    await Hive.openBox(boxName ?? _defaultBoxName);
  }

  /// Streams data from a specified key in a Hive box based on the provided [stream].
  ///
  /// [key] is the unique identifier for the data.
  /// [stream] is the source stream to listen for updates.
  /// [boxName] is an optional parameter that allows you to specify a custom box name.
  /// [waitForConnection] is an optional parameter that, if set to true, will wait for an internet connection before streaming data.
  ///
  /// Yields a [FlutterPersistenceResponse] with the initial data, and subsequently
  /// yields updated data as it becomes available.
  ///
  /// Throws [NotAllowedTypeException] if the data type is not supported.
  static Stream<FlutterPersistenceResponse<T>> stream<T>(
      {required String key,
      required Stream<T> stream,
      String? boxName,
      bool waitForConnection = false}) async* {
    _checkValidType<T>();

    final Box box = _getHiveBox(boxName);

    final T? initialData = _getInitialData(key, box);

    yield FlutterPersistenceResponse(
        response: initialData,
        type: initialData == null
            ? FlutterPersistenceResponseType.waiting
            : FlutterPersistenceResponseType.cached);

    if (waitForConnection) {
      await _waitForConnection();
    }

    await for (var changes in stream) {
      await _writeData(key, changes, box);
      yield FlutterPersistenceResponse(
          response: changes, type: FlutterPersistenceResponseType.updated);
    }
  }

  /// Retrieves and caches data from a specified key in a Hive box based on the provided [future].
  ///
  /// [key] is the unique identifier for the data.
  /// [future] is the future that provides the updated data.
  /// [boxName] is an optional parameter that allows you to specify a custom box name.
  /// [waitForConnection] is an optional parameter that, if set to true, will wait for an internet connection before fetching data.
  ///
  /// Yields a [FlutterPersistenceResponse] with the initial data and subsequently
  /// the updated data after the future completes.
  ///
  /// Throws [NotAllowedTypeException] if the data type is not supported.
  static Stream<FlutterPersistenceResponse<T>> future<T>(
      {required String key,
      required Future<T> future,
      String? boxName,
      bool waitForConnection = false}) async* {
    _checkValidType<T>();

    final Box box = _getHiveBox(boxName);

    final T? initialData = _getInitialData(key, box);

    yield FlutterPersistenceResponse(
        response: initialData,
        type: initialData == null
            ? FlutterPersistenceResponseType.waiting
            : FlutterPersistenceResponseType.cached);

    if (waitForConnection) {
      await _waitForConnection();
    }

    T changes = await future;
    await _writeData(key, changes, box);
    yield FlutterPersistenceResponse(
        response: changes, type: FlutterPersistenceResponseType.updated);
  }

  /// Clears all data stored by Hive.
  ///
  /// Throws [NotInitializedException] if Hive is not initialized.
  static Future<void> clearAll() async {
    try {
      await Hive.deleteFromDisk();
    } on HiveError {
      throw NotInitializedException(null);
    }
  }

  /// Clears the data stored in a specific Hive box.
  ///
  /// [boxName] is an optional parameter that allows you to specify a custom box name.
  ///
  /// Throws [NotInitializedException] if Hive is not initialized.
  static Future<void> clearBox([String? boxName]) async {
    try {
      Hive.deleteBoxFromDisk(boxName ?? _defaultBoxName);
    } on HiveError {
      throw NotInitializedException(boxName);
    }
  }

  /// Clears data associated with a specific key in a Hive box.
  ///
  /// [key] is the unique identifier for the data.
  /// [boxName] is an optional parameter that allows you to specify a custom box name.
  ///
  /// Throws [NotInitializedException] if Hive is not initialized.
  /// Throws [NotExistingKey] if the key does not exist in the specified box.
  static Future<void> clearKey(String key, [String? boxName]) async {
    final Box box;
    try {
      box = Hive.box(boxName ?? _defaultBoxName);
    } on HiveError {
      throw NotInitializedException(boxName);
    }

    if (!box.containsKey(key)) {
      throw NotExistingKey();
    }

    await box.delete(key);
  }

  // Private methods (not intended for external use):

  /// Check for connection and wait if there is not connection
  static Future<void> _waitForConnection() async {
    while (true) {
      bool isConnected =
          (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
      if (isConnected) {
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// Writes data to a specified key in a Hive box.
  static Future<void> _writeData<T>(String key, T data, Box box) async {
    try {
      await box.put(key, data);
    } on HiveError {
      throw NotAllowedTypeException();
    }
  }

  /// Retrieves and returns the initial data from a specified key in a Hive box.
  static T? _getInitialData<T>(String key, Box box) {
    try {
      return _getDataFromBox<T>(key, box);
    } on NotAllowedTypeException {
      throw NotAllowedTypeException();
    } on HiveError {
      throw NotAllowedDynamicTypeException();
    }
  }

  /// Checks if the data type is valid and supported.
  static _ValidType _checkValidType<T>() {
    final type = T.toString();
    if (type == "Map<String, dynamic>") {
      return _ValidType.mapStringDynamic;
    } else if (type == "List<Map<String, dynamic>>") {
      return _ValidType.listMapStringDynamic;
    } else if (type == "Map<dynamic, dynamic>" ||
        type == "List<dynamic>" ||
        type == "List<int>" ||
        type == "List<double>" ||
        type == "List<String>" ||
        type == "int" ||
        type == "double" ||
        type == "String") {
      return _ValidType.otherValidData;
    }
    throw NotAllowedTypeException();
  }

  /// Retrieves data from a specified key in a Hive box and casts it to the appropriate type.
  static Box _getHiveBox(String? boxName) {
    try {
      return Hive.box(boxName ?? _defaultBoxName);
    } on HiveError {
      throw NotInitializedException(boxName);
    }
  }

  /// Retrieves a Hive box, either the default or a custom one specified by [boxName].
  static T? _getDataFromBox<T>(String key, Box box) {
    final alreadyPresent = box.containsKey(key);
    if (!alreadyPresent) return null;
    final validType = _checkValidType<T>();
    try {
      if (validType == _ValidType.mapStringDynamic) {
        return Map<String, dynamic>.from(box.get(key) as Map) as T;
      } else if (validType == _ValidType.listMapStringDynamic) {
        return (box.get(key) as List<dynamic>)
            .map((map) => Map<String, dynamic>.from(map))
            .toList() as T;
      } else if (validType == _ValidType.otherValidData) {
        return box.get(key) as T;
      } else {
        throw NotAllowedTypeException();
      }
    } on HiveError {
      throw NotAllowedTypeException();
    }
  }
}
