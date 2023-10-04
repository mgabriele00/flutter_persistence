import 'package:flutter/material.dart';
import 'package:flutter_persistence/flutter_persistence.dart';

void main() async {
  // Initialize Flutter Persistence before running the app.
  await FlutterPersistence.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // A fake asynchronous stream generator for demonstration purposes.
  Stream<int> buildFakeStream() async* {
    await Future.delayed(const Duration(seconds: 3));
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield i;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate the fake stream and persist it using Flutter Persistence.
    final myStream = buildFakeStream();
    final persistedStream =
    FlutterPersistence.stream(key: "fakeStream", stream: myStream);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Persistence"),
      ),
      body: StreamBuilder(
        stream: persistedStream,
        builder: (context, snap) {
          if (snap.hasData) {
            // Display the data from the persisted stream.
            return Text(snap.data.toString());
          } else if (snap.hasError) {
            // Handle and display any errors that occur during streaming.
            return Text(snap.error.toString());
          }
          // Display an empty container while waiting for data.
          return Container();
        },
      ),
    );
  }
}
