import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/view_model/user_view_model.dart';
import 'package:user_app/views/user_list/user_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UserViewModel()..fetchUserList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const UserListScreen(),
      ),
    );
  }
}
