import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database.dart';
import 'ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final db = Database();
    return Provider<Database>(
      // The single instance of Database
      create: (context) => db,
      dispose: (context, db) => db.close(),
      child: MaterialApp(
        title: 'Tasks Drift Example',
        home: HomePage(),
      ),
    );
  }
}
