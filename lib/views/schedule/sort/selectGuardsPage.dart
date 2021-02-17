import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/cards/guardCard.dart';
import 'package:vigilancia_app/views/shared/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/header/internalHeaderWithTabBarx5.dart';
import 'package:vigilancia_app/views/shared/titleOrRowBuilder/TitleOrRowBuilder.dart';

List<Guard> guardList = List();
List<Guard> doormanList = List();

List<Guard> selectedGuards = List();

class SelectGuardsPage extends StatefulWidget {
  @override
  _SelectGuardsPageState createState() => _SelectGuardsPageState();
}

class _SelectGuardsPageState extends State<SelectGuardsPage> {
  bool isDaytime = SingletonSchedule().isDaytime;

  @override
  void initState() {
    // TODO: implement initState
    selectedGuards = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GuardStream = FirebaseFirestore.instance
        .collection("guards")
        .where('visible', isEqualTo: true)
        .orderBy('name')
        .get();
    return FutureBuilder(
      future: GuardStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return selectGuardsPageHeader(
              widget1: ContainerWithCircularProgress(),
              widget2: ContainerWithCircularProgress(),
              widget3: ContainerWithCircularProgress(),
              widget4: ContainerWithCircularProgress(),
              widget5: ContainerWithCircularProgress());
        } else if (snapshot.hasError) {
          return selectGuardsPageHeader(
              widget1: ContainerWithErrorMessage(snapshot.error.toString()),
              widget2: ContainerWithErrorMessage(snapshot.error.toString()),
              widget3: ContainerWithErrorMessage(snapshot.error.toString()),
              widget4: ContainerWithErrorMessage(snapshot.error.toString()),
              widget5: ContainerWithErrorMessage(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          doormanList.clear();
          guardList.clear();
          snapshot.data.docs.forEach((element) {
            if (element['type'] == 0) {
              guardList.add(docToGuard(element));
            } else {
              doormanList.add(docToGuard(element));
            }
          });
          return selectGuardsPageHeader(
            widget1: SelectGuardsSubPage(
              tabBarIndex: 0,
            ),
            widget2: SelectGuardsSubPage(
              tabBarIndex: 1,
            ),
            widget3: SelectGuardsSubPage(
              tabBarIndex: 2,
            ),
            widget4: SelectGuardsSubPage(
              tabBarIndex: 3,
            ),
            widget5: SelectGuardsSubPage(
              tabBarIndex: 4,
            ),
          );
        } else {
          return selectGuardsPageHeader(
              widget1: ContainerWithErrorMessage(""),
              widget2: ContainerWithErrorMessage(""),
              widget3: ContainerWithErrorMessage(""),
              widget4: ContainerWithErrorMessage(""),
              widget5: ContainerWithErrorMessage(""));
        }
      },
    );
  }

  Widget selectGuardsPageHeader(
      {Key key,
      Widget widget1,
      Widget widget2,
      Widget widget3,
      Widget widget4,
      Widget widget5}) {
    return InternalHeaderWithTabBarx5(
      title: "Sortear - " + (isDaytime ? "Diurno" : "Noturno"),
      rightIcon1: Icons.refresh,
      rightIcon1Function: () {
        setState(() {});
      },
      leftIconFunction: () {
        Navigator.of(context).pop();
      },
      leftIcon: Icons.arrow_back_ios,
      text1: "A-D",
      text2: "A",
      text3: "B",
      text4: "C",
      text5: "D",
      widget1: widget1,
      widget2: widget2,
      widget3: widget3,
      widget4: widget4,
      widget5: widget5,
    );
  }
}

class SelectGuardsSubPage extends StatefulWidget {
  List<Guard> doormanListLocal = List();
  List<Guard> guardListLocal = List();

  int tabBarIndex;

  SelectGuardsSubPage({
    Key key,
    this.tabBarIndex,
    /* this.guardList, this.doormanList*/
  }) : super(key: key);

  @override
  _SelectGuardsSubPageState createState() => _SelectGuardsSubPageState();
}

class _SelectGuardsSubPageState extends State<SelectGuardsSubPage> {
  Size get size => MediaQuery.of(context).size;
  String team;
  bool hasSelectAllOptionOnDoormans = false;
  bool hasSelectAllOptionOnGuards = false;
  int isAllSelected = 0;

  @override
  Widget build(BuildContext context) {
    switch (widget.tabBarIndex) {
      case 0:
        {
          team = "";
          break;
        }
      case 1:
        {
          team = "A";
          break;
        }
      case 2:
        {
          team = "B";
          break;
        }
      case 3:
        {
          team = "C";
          break;
        }
      case 4:
        {
          team = "D";
          break;
        }
    }

    widget.doormanListLocal.clear();
    widget.guardListLocal.clear();
    if (team.isEmpty) {
      widget.doormanListLocal.addAll(doormanList);
      widget.guardListLocal.addAll(guardList);
    } else {
      doormanList.forEach((element) {
        if (element.team == team) {
          widget.doormanListLocal.add(element);
        }
      });
      guardList.forEach((element) {
        if (element.team == team) {
          widget.guardListLocal.add(element);
        }
      });
    }

    if (widget.doormanListLocal.isNotEmpty) {
      hasSelectAllOptionOnDoormans = true;
    } else if (widget.guardListLocal.isNotEmpty) {
      hasSelectAllOptionOnGuards = true;
    }

    updateSelectAllCheckBoxStatus();

    if (widget.doormanListLocal.length + widget.guardListLocal.length == 0) {
      return Container(
          alignment: Alignment.center,
          child: Text(
            "Desculpe! Não encontrei ninguém cadastrado neste time :(",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ));
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount:
            widget.doormanListLocal.length + widget.guardListLocal.length,
        itemBuilder: guardItemBuiler,
      );
    }
  }

  //ItemBuilder
  Widget guardItemBuiler(BuildContext context, int index) {
    if (widget.doormanListLocal.length != 0 &&
        index <= (widget.doormanListLocal.length - 1)) {
      if (index == 0) {
        if (widget.guardListLocal.length == 0 &&
            widget.doormanListLocal.length == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: hasSelectAllOptionOnDoormans,
                  child: selectAllOption()),
              TitleBuilder(
                  title: "PORTEIROS", padding: EdgeInsets.only(bottom: 5)),
              guardCardBuilder(widget.doormanListLocal.elementAt(index)),
              Container(
                width: size.width,
                child: buttonBuilder(),
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: hasSelectAllOptionOnDoormans,
                  child: selectAllOption()),
              TitleBuilder(
                  title: "PORTEIROS", padding: EdgeInsets.only(bottom: 5)),
              guardCardBuilder(widget.doormanListLocal.elementAt(index))
            ],
          );
        }
      } else if (widget.guardListLocal.length == 0 &&
          index == (widget.doormanListLocal.length - 1)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            guardCardBuilder(widget.doormanListLocal.elementAt(index)),
            Container(
              width: size.width,
              child: buttonBuilder(),
            ),
          ],
        );
      } else {
        return guardCardBuilder(widget.doormanListLocal.elementAt(index));
      }
    } else if (widget.guardListLocal.length != 0 &&
        index > (widget.doormanListLocal.length - 1)) {
      if (index == widget.doormanListLocal.length) {
        if (widget.guardListLocal.length == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: hasSelectAllOptionOnGuards,
                  child: selectAllOption()),
              TitleBuilder(
                  title: "VIGILANTES",
                  padding: EdgeInsets.only(bottom: 5, top: 20)),
              guardCardBuilder(widget.guardListLocal
                  .elementAt(index - widget.doormanListLocal.length)),
              Container(
                width: size.width,
                child: buttonBuilder(),
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: hasSelectAllOptionOnGuards,
                  child: selectAllOption()),
              TitleBuilder(
                  title: "VIGILANTES",
                  padding: EdgeInsets.only(bottom: 5, top: 20)),
              guardCardBuilder(widget.guardListLocal
                  .elementAt(index - widget.doormanListLocal.length))
            ],
          );
        }
      } else if (index ==
          widget.guardListLocal.length + widget.doormanListLocal.length - 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            guardCardBuilder(widget.guardListLocal
                .elementAt(index - widget.doormanListLocal.length)),
            Container(
              width: size.width,
              child: buttonBuilder(),
            )
          ],
        );
      } else {
        return guardCardBuilder(widget.guardListLocal
            .elementAt(index - widget.doormanListLocal.length));
      }
    } else {
      return ContainerWithErrorMessage("");
    }
  }

  void updateSelectAllCheckBoxStatus(){
    //LOAD ISALLSELECTED INFO
    bool isAtLeastOneSelectedInList = false;
    bool isAllCheckedInList = true;

    widget.guardListLocal.forEach((element) {
      bool contains = false;
      selectedGuards.forEach((elementSelected) {
        if (elementSelected.id == element.id) contains = true;
      });

      if (contains) {
        isAtLeastOneSelectedInList = true;
      } else {
        isAllCheckedInList = false;
      }
    });

    widget.doormanListLocal.forEach((element) {
      bool contains = false;
      selectedGuards.forEach((elementSelected) {
        if (elementSelected.id == element.id) contains = true;
      });

      if (contains) {
        isAtLeastOneSelectedInList = true;
      } else {
        isAllCheckedInList = false;
      }
    });

    if (isAtLeastOneSelectedInList) isAllSelected = 1;

    if (isAllCheckedInList) isAllSelected = 2;
  }

  Widget guardCardBuilder(Guard guard) {
    bool isChecked = false;
    selectedGuards.forEach((element) {
      if (element.id == guard.id) {
        isChecked = true;
      }
    });

    return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          child: GuardCard(
            name: guard.name,
            id: guard.id,
            type: guard.type,
            cpf: guard.cpf,
            isChecked: isChecked,
            checkFunction:
                (int id, bool isChecked, String name, int type, String cpf) {
              Guard guard = new Guard(id: id, name: name, type: type, cpf: cpf);
              if (isChecked) {
                selectedGuards.add(guard);
              } else {
                selectedGuards.removeWhere((element) => element.id == guard.id);
              }
              setState(() {
                isAllSelected = 0;
                updateSelectAllCheckBoxStatus();
              });
            },
          ),
        ));
  }

  Widget buttonBuilder() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: AppButton(
        labelText: "PROSSEGUIR",
        onPressedFunction: () {
          print(selectedGuards.toString());
          List<Guard> singletonSelectedGuards = new List();
          List<Guard> singletonSelectedDoormans = new List();
          selectedGuards.forEach((element) {
            if (element.type == 1) {
              singletonSelectedDoormans.add(element);
            } else {
              singletonSelectedGuards.add(element);
            }
          });
          SingletonSchedule().selectedGuards = singletonSelectedGuards;
          SingletonSchedule().selectedDoormans = singletonSelectedDoormans;
          print("selected doormans..." + singletonSelectedDoormans.toString());
          Navigator.pushNamed(context, 'schedule/selectWorkplacesPage');
        },
      ),
    );
  }

  Widget selectAllOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(isAllSelected == 0
                ? Icons.check_box_outline_blank
                : isAllSelected == 1
                    ? Icons.indeterminate_check_box_outlined
                    : Icons.check_box_outlined),
            onPressed: () {
              setState(() {
                if (isAllSelected == 2) {
                  isAllSelected = 0;
                } else {
                  isAllSelected = 2;
                }
                if (isAllSelected == 2) {
                  widget.guardListLocal.forEach((element) {
                    bool flag = false;
                    selectedGuards.forEach((elementSelected) {
                      if (elementSelected.id == element.id) {
                        flag = true;
                      }
                    });
                    if (flag == false) {
                      selectedGuards.add(element);
                    }
                  });
                  widget.doormanListLocal.forEach((element) {
                    bool flag = false;
                    selectedGuards.forEach((elementSelected) {
                      if (elementSelected.id == element.id) {
                        flag = true;
                      }
                    });
                    if (flag == false) {
                      selectedGuards.add(element);
                    }
                  });
                } else {
                  widget.guardListLocal.forEach((element) {
                    Guard guardToDelete = new Guard();
                    selectedGuards.forEach((elementSelected) {
                      if (elementSelected.id == element.id)
                        guardToDelete = elementSelected;
                    });
                    selectedGuards.remove(guardToDelete);
                  });

                  widget.doormanListLocal.forEach((element) {
                    Guard guardToDelete = new Guard();
                    selectedGuards.forEach((elementSelected) {
                      if (elementSelected.id == element.id)
                        guardToDelete = elementSelected;
                    });
                    selectedGuards.remove(guardToDelete);
                  });
                }
              });
            }),
        Text(
          "Selecionar Todos",
          style: TextStyle(fontSize: 19),
        )
      ],
    );
  }
}

Widget ContainerWithCircularProgress() {
  return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(),
  );
}

Widget ContainerWithErrorMessage(String erro) {
  return Container(
      alignment: Alignment.center,
      child: Text(
        "Erro Encontrado :( \n" + erro,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ));
}

//Future
var GuardStream = FirebaseFirestore.instance
    .collection("guards")
    .where('visible', isEqualTo: true)
    .orderBy('name')
    .get();
