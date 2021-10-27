import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/models/user.dart';
import 'package:user_app/resources/utils/fetch_exception.dart';

import 'api_url.dart';

class ApiServices {
  // Map<String, String> header = {
  //   'Accept': '*/*',
  //   //'Content-Type': 'application/json;',
  //   'Accept-Encoding': 'gzip, deflate, br'
  // };
  // String accessToken = "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";
  // void addHeader() {
  //   header['Authorization'] = 'Bearer ' + accessToken;
  // }

  Future<List<User>> fetchUser() async {
    List<User> listResponse = [];
    dynamic userList;
    // addHeader();
    try {
      var response = await http.get(
        Uri.parse(ApiUrls().apiUserList),
      );
      final String jsonBody = response.body;
      final int statusCode = response.statusCode;
      await saveToSharedPreferences("listUser", jsonBody);
      if (statusCode != 200) {
        throw FetchDataException(
            "StatusCode:$statusCode, Error:${response.reasonPhrase}");
      } else {
        userList = jsonDecode(jsonBody);
      }
    } on Exception catch (e) {
      log(e.toString());
      String jsonBodyCatches = await getValueSharedPreferences("listUser");
      userList = jsonDecode(jsonBodyCatches);
    }
    listResponse = userList.map<User>((e) => User.fromJson(e)).toList();
    return listResponse;
  }

  Future<User> getUserDetail(int id) async {
    //addHeader();
    String url = ApiUrls().apiUserList + "/" + id.toString();
    var response = await http.get(Uri.parse(url));

    final String jsonBody = response.body;
    final int statusCode = response.statusCode;

    if (statusCode != 200) {
      throw FetchDataException(
          "StatusCode:$statusCode, Error:${response.reasonPhrase}");
    }
    final user = jsonDecode(jsonBody);
    return User.fromJson(user);
  }
}

saveToSharedPreferences(String key, dynamic data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);
}

dynamic getValueSharedPreferences(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get(key);
}
