import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:user_app/date_sources/api_service.dart';

import 'package:user_app/models/user.dart';

class UserViewModel with ChangeNotifier {
  List<User> userList = [];
  late User user;
  int i = 0;
  fetchUserList() async {
    try {
      userList = await ApiServices().fetchUser();
    } on Exception catch (e) {
      log(e.toString());
    }
    i++;
    notifyListeners();
  }

  getUserDetail(int id) async {
    try {
      user = await ApiServices().getUserDetail(id);
    } on Exception catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }
}
