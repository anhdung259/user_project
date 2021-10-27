import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:user_app/resources/utils/colors.dart';
import 'package:user_app/resources/utils/strings.dart';
import 'package:user_app/view_model/user_view_model.dart';
import 'package:user_app/views/user_detail/user_detail.dart';
import 'package:user_app/views/user_list/components/user_item.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  onRefresh(UserViewModel userViewModel, BuildContext context) async {
    userViewModel.userList.clear();
    await Future.delayed(const Duration(seconds: 2));
    await userViewModel.fetchUserList();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          title: const Text(
            userList,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Consumer<UserViewModel>(builder: (context, userViewModel, child) {
          return Container(
              padding: const EdgeInsets.only(left: 10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              child: userViewModel.userList.isNotEmpty
                  ? SmartRefresher(
                      enablePullDown: true,
                      controller: refreshController,
                      onRefresh: () => onRefresh(userViewModel, context),
                      child: ListView.builder(
                          itemCount: userViewModel.userList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return UserItem(
                              function: () async {
                                await userViewModel.getUserDetail(
                                    userViewModel.userList[index].id!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => UserDetail(
                                              id: userViewModel
                                                  .userList[index].id!,
                                            )));
                              },
                              user: userViewModel.userList[index],
                            );
                          }),
                    )
                  : const Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                      ),
                    ));
        }));
  }
}
