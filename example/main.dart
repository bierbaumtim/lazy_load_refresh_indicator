import 'package:flutter/material.dart';

import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int itemCount = 20;
  bool isLoading = false;

  Future<void> onRefresh() async => Future.delayed(
        const Duration(seconds: 2),
        () => setState(() => itemCount = 20),
      );

  void onEndOfPage() {
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        itemCount += 20;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Some Title'),
      ),
      body: LazyLoadRefreshIndicator(
        onEndOfPage: onEndOfPage,
        onRefresh: onRefresh,
        scrollOffset: 150,
        isLoading: isLoading,
        child: ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text('$index'),
          ),
          itemCount: itemCount,
        ),
      ),
    );
  }
}
