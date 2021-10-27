import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:user_app/resources/utils/app_textstyle.dart';
import 'package:user_app/resources/utils/colors.dart';
import 'package:user_app/resources/utils/strings.dart';
import 'package:user_app/view_model/user_view_model.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);
    onRefresh(UserViewModel userViewModel, BuildContext context) async {
      await Future.delayed(const Duration(seconds: 1));
      await userViewModel.getUserDetail(id);
      refreshController.refreshCompleted();
    }

    return Consumer<UserViewModel>(builder: (context, userViewModel, child) {
      return Scaffold(
          body: SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          controller: refreshController,
          onRefresh: () => onRefresh(userViewModel, context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 280,
                      width: double.infinity,
                      child: Image.network(
                        backgroundUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: white,
                            )),
                        const Padding(
                          padding: EdgeInsets.only(left: 123),
                          child: Text(userdetail,
                              style: TextStyle(color: white, fontSize: 25)),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2)),
                        height: 120,
                        width: 120,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            height: 80.0,
                            width: 80.0,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            imageUrl: userViewModel.user.avatarUrl!,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                        child: Text(userViewModel.user.name ?? notInfo,
                            style: AppStyle.h1)),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(userViewModel.user.location ?? notInfo,
                        style: AppStyle.textNormal),
                    const Divider(
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InfoProfile(
                          number: userViewModel.user.followers ?? 0,
                          title: "Followers",
                        ),
                        InfoProfile(
                          number: userViewModel.user.following ?? 0,
                          title: "Following",
                        ),
                        InfoProfile(
                          number: userViewModel.user.repos ?? 0,
                          title: "Repos",
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bio",
                            style: AppStyle.h2,
                          ),
                          Text(userViewModel.user.bio ?? "User bio here...."),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    });
  }
}

class InfoProfile extends StatelessWidget {
  const InfoProfile({
    Key? key,
    required this.number,
    required this.title,
  }) : super(key: key);
  final int number;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(number.toString(), style: AppStyle.number),
      Text(title, style: AppStyle.title),
    ]);
  }
}
