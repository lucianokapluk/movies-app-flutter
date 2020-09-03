import 'package:flutter/material.dart';

import 'package:flutter_movies/src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movies',
        initialRoute: '/',
        routes: getApplicationRoutes());
  }
}
