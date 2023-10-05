# Flutter Persistence

Flutter Persistence is a library for persisting and retrieving data in Flutter applications using Hive as a local storage solution. It provides a convenient way to store and access data, including streaming and future-based operations.

## Getting Started

Before using Flutter Persistence, you need to initialize it using the `init` method. This initializes Hive and opens a storage box for data storage.

```dart  
await FlutterPersistence.init()  
```  

## Supported Data Types

Flutter Persistence supports the following data types:

- `Map<String, dynamic>`
- `Map<dynamic, dynamic>`
- `List<Map<String, dynamic>>`
- `List<dynamic>`
- `List<int>`
- `List<double>`
- `List<String>`
- `int`
- `double`
- `String`

**Note:** When using dynamic data, it must be of one of the allowed types listed above.

## Usage Examples

### Streaming Data

You can stream data and persist it using Flutter Persistence. For example:

```dart  
final persistedStream = FlutterPersistence.stream(key: "myStreamKey", stream: myStream);  
```  

**Note:** For supabase is recommended to set waitForConnection = true.

### Future-Based Operations

You can also work with future-based operations. For example:

```dart  
final cachedFuture = FlutterPersistence.future(key: "myFutureKey", stream: myFuture);  
```

## Exception Handling

Flutter Persistence provides several exception classes for handling errors:

- `NotAllowedTypeException`: Thrown when an invalid data type is encountered.
- `NotAllowedDynamicTypeException`: Thrown when an invalid dynamic data type is encountered.
- `NotInitializedException`: Thrown when an operation is performed without initializing Flutter Persistence.
- `NotExistingKey`: Thrown when a key is not found in the cache.

## Contribution

Contributions to Flutter Persistence are welcome! Feel free to submit issues, pull requests, or suggestions to help improve this library.

## License

This library is licensed under the MIT License.
```  
MIT License  
  
Copyright (c) 2023 Gabriele Marra  
  
Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:  
  
The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.  
  
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
SOFTWARE.
```