import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:tutorapp/analytics_services/analytics_servicers.dart';
import 'package:tutorapp/chatUI/post_stats.dart';
import 'package:tutorapp/helper/demo_values.dart';
import 'package:tutorapp/models/post_model.dart';
import 'package:tutorapp/models/user_model.dart';
import 'package:tutorapp/pages/post_page.dart';
import 'package:tutorapp/presentation/themes.dart';
import 'package:tutorapp/widgets/inherited_widgets/inherited_post_model.dart';
import 'package:tutorapp/widgets/inherited_widgets/inherited_user_model.dart';

bool isLandscape(BuildContext context) =>
    MediaQuery.of(context).orientation == Orientation.landscape;

class PostCard extends StatelessWidget {
  // Data
  final PostModel postData;
  

  // Data will be taken using the constructor
  const PostCard({Key? key, required this.postData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double aspectRatio = isLandscape(context) ? 6 / 2 : 6 / 3;

    return GestureDetector(
        onTap: () {
          
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return PostPage(postData: postData);
          }));
        },
        child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
                height: double.infinity,
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: InheritedPostModel(
                    postData: postData,
                    child: Column(children: <Widget>[
                      _Post(),
                      Divider(color: Colors.grey),
                      _PostDetails(),
                    ]),
                  ),
                ))));
  }
}

class _Post extends StatelessWidget {
  const _Post({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_PostImage(), _PostTitleAndSummary()],
      ),
    );
  }
}

class _PostTitleAndSummary extends StatelessWidget {
  const _PostTitleAndSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Getting data from inherited widget
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle? titleTheme = Theme.of(context).textTheme.headline6;
    final TextStyle? summaryTheme = Theme.of(context).textTheme.bodyText2;
    // using data retrieved from inherited widget
    final String title = postData.title;
    final String summary = postData.summary;
    final int flex = isLandscape(context) ? 5 : 3;

    return Expanded(
        flex: flex,
        child: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(title, style: titleTheme),
              Text(summary, style: summaryTheme),
            ],
          ),
        ));
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    return Expanded(
        flex: 2, child: Image.asset(postData.imageURL, fit: BoxFit.cover));
  }
}

class _PostDetails extends StatelessWidget {
  const _PostDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    return Row(
      children: <Widget>[
        Expanded(flex: 3, child: UserDetails(userData: postData.author)),
        Expanded(flex: 1, child: PostStats()),
      ],
    );
  }
}

class UserDetails extends StatelessWidget {
  final UserModel userData;

  const UserDetails({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InheritedUserModel(
      userData: userData,
      child: Container(
        child: Row(children: <Widget>[_UserImage(), _UserNameAndEmail()]),
      ),
    );
  }
}

class _UserNameAndEmail extends StatelessWidget {
  const _UserNameAndEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel userData = InheritedUserModel.of(context).userData;
    return Expanded(
      flex: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(userData.name),
          Text(userData.email),
        ],
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel userData = InheritedUserModel.of(context).userData;
    return Expanded(
      flex: 1,
      child: CircleAvatar(
        backgroundImage: AssetImage(userData.image),
      ),
    );
  }
}

class PostTimeStamp extends StatelessWidget {
  final Alignment alignment;

  const PostTimeStamp({
    Key? key,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostModel postData = InheritedPostModel.of(context).postData;
    final TextStyle timeTheme = TextThemes.dateStyle;

    return Container(
      width: double.infinity,
      alignment: alignment,
      child: Text(postData.postTimeFormatted, style: timeTheme),
    );
  }
}
