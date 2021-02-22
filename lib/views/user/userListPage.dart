import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/components/header/InternalHeaderWithTabBar.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return InternalHeaderWithTabBar(
      tabQuantity_x2_or_x3: 3,
      title: "Usuários",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      rightIcon1: Icons.add,
      rightIcon1Function: () {
        Navigator.pushNamed(context, 'user/registration');
      },
      text1: "Todos",
      text2: "Adm",
      text3: "Líder",
      widget1: UserListSubPage(
        index: 0,
      ),
      widget2: UserListSubPage(
        index: 1,
      ),
      widget3: UserListSubPage(
        index: 2,
      ),
    );
  }
}

class UserListSubPage extends StatefulWidget {
  int index;

  UserListSubPage({Key key, this.index}) : super(key: key);

  @override
  _UserListSubPageState createState() => _UserListSubPageState();
}

class _UserListSubPageState extends State<UserListSubPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
