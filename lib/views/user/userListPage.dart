import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/user/user.dart';
import 'package:vigilancia_app/views/shared/components/cards/guardCard.dart';
import 'package:vigilancia_app/views/shared/components/header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/components/widgetStreamOrFutureBuilder/widgetStreamOrFutureBuilder.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    var _UserFuture = FirebaseFirestore.instance
        .collection("users")
        .where('visible', isEqualTo: true)
        .orderBy('name')
        .get();
    return FutureBuilder(
      future: _UserFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return UserListPageHeader(
              widget1: containerWithCircularProgress(),
              widget2: containerWithCircularProgress(),
              widget3: containerWithCircularProgress());
        } else if (snapshot.hasError) {
          return UserListPageHeader(
              widget1: containerWithErrorMessage(snapshot.error.toString()),
              widget2: containerWithErrorMessage(snapshot.error.toString()),
              widget3: containerWithErrorMessage(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          return UserListPageHeader(
            widget1: UserListSubPage(
              index: 0,
              snapshot: snapshot,
            ),
            widget2: UserListSubPage(
              index: 1,
              snapshot: snapshot,
            ),
            widget3: UserListSubPage(
              index: 2,
              snapshot: snapshot,
            ),
          );
        } else {
          return UserListPageHeader(
              widget1: containerWithErrorMessage(""),
              widget2: containerWithErrorMessage(""),
              widget3: containerWithErrorMessage(""));
        }
      },
    );
  }

  Widget UserListPageHeader(
      {Key key, Widget widget1, Widget widget2, Widget widget3}) {
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
      widget1: widget1,
      widget2: widget2,
      widget3: widget3,
    );
  }
}

class UserListSubPage extends StatefulWidget {
  int index;
  AsyncSnapshot<QuerySnapshot> snapshot;

  UserListSubPage({Key key, this.index, this.snapshot}) : super(key: key);

  @override
  _UserListSubPageState createState() => _UserListSubPageState();
}

class _UserListSubPageState extends State<UserListSubPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.snapshot.data.docs.length == 0) {
      return containerWithNotFoundMessage(
          "Desculpe! Não encontrei nenhum usuário :(");
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: widget.snapshot.data.docs.length,
        itemBuilder: workplaceItemBuilder,
      );
    }
  }

  Widget workplaceItemBuilder(BuildContext context, int index) {
    User userToShow = docToUser(widget.snapshot.data.docs.elementAt(index));
    if(widget.index == 0){
      return userCardBuilder(userToShow);
    }else{
      if (userToShow.type + 1 == widget.index)
        return userCardBuilder(userToShow);
      else
        return Container(
          height: 0,
        );
    }
    

  }

  Widget userCardBuilder(User userToShow) {
    return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          child: GuardCard(
            onCardTap: () {
/*              SingletonGuard().guard = guard;
              SingletonGuard().isUpdate = true;
              Navigator.pushNamed(context, 'guard/registration');*/
            },
            name: userToShow.name,
            id: userToShow.id,
            type: userToShow.type,
            cpf: userToShow.matricula,
            hasCkeckBox: false,
          ),
        ));
  }
}
