import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/cards/guardCard.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeaderWithTabBarx5.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';
import 'package:vigilancia_app/views/shared/components/widgetStreamOrFutureBuilder/widgetStreamOrFutureBuilder.dart';

List<Guard> _guardList = List();
List<Guard> _doormanList = List();

List<Guard> _selectedGuards = List();

class SelectGuardsPage extends StatefulWidget {
  @override
  _SelectGuardsPageState createState() => _SelectGuardsPageState();
}

class _SelectGuardsPageState extends State<SelectGuardsPage> {
  bool _isDaytime = SingletonSchedule().isDaytime;

  @override
  void initState() {
    // TODO: implement initState
    _selectedGuards = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _GuardStream = FirebaseFirestore.instance
        .collection("guards")
        .where('visible', isEqualTo: true)
        .orderBy('name')
        .get();
    return FutureBuilder(
      future: _GuardStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return selectGuardsPageHeader(
              widget1: containerWithCircularProgress(),
              widget2: containerWithCircularProgress(),
              widget3: containerWithCircularProgress(),
              widget4: containerWithCircularProgress(),
              widget5: containerWithCircularProgress());
        } else if (snapshot.hasError) {
          return selectGuardsPageHeader(
              widget1: containerWithErrorMessage(snapshot.error.toString()),
              widget2: containerWithErrorMessage(snapshot.error.toString()),
              widget3: containerWithErrorMessage(snapshot.error.toString()),
              widget4: containerWithErrorMessage(snapshot.error.toString()),
              widget5: containerWithErrorMessage(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          _doormanList.clear();
          _guardList.clear();
          snapshot.data.docs.forEach((element) {
            if (element['type'] == 0) {
              _guardList.add(docToGuard(element));
            } else {
              _doormanList.add(docToGuard(element));
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
              widget1: containerWithErrorMessage(""),
              widget2: containerWithErrorMessage(""),
              widget3: containerWithErrorMessage(""),
              widget4: containerWithErrorMessage(""),
              widget5: containerWithErrorMessage(""));
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
      title: "Sortear - " + (_isDaytime ? "Diurno" : "Noturno"),
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
  List<Guard> _doormanListLocal = List();
  List<Guard> _guardListLocal = List();

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
  Size get _size => MediaQuery.of(context).size;
  String _team;
  bool _hasSelectAllOptionOnDoormans = false;
  bool _hasSelectAllOptionOnGuards = false;
  int _isAllSelected = 0;

  @override
  Widget build(BuildContext context) {
    switch (widget.tabBarIndex) {
      case 0:
        {
          _team = "";
          break;
        }
      case 1:
        {
          _team = "A";
          break;
        }
      case 2:
        {
          _team = "B";
          break;
        }
      case 3:
        {
          _team = "C";
          break;
        }
      case 4:
        {
          _team = "D";
          break;
        }
    }

    widget._doormanListLocal.clear();
    widget._guardListLocal.clear();
    if (_team.isEmpty) {
      widget._doormanListLocal.addAll(_doormanList);
      widget._guardListLocal.addAll(_guardList);
    } else {
      _doormanList.forEach((element) {
        if (element.team == _team) {
          widget._doormanListLocal.add(element);
        }
      });
      _guardList.forEach((element) {
        if (element.team == _team) {
          widget._guardListLocal.add(element);
        }
      });
    }

    if (widget._doormanListLocal.isNotEmpty) {
      _hasSelectAllOptionOnDoormans = true;
    } else if (widget._guardListLocal.isNotEmpty) {
      _hasSelectAllOptionOnGuards = true;
    }

    updateSelectAllCheckBoxStatus();

    if (widget._doormanListLocal.length + widget._guardListLocal.length == 0) {
      return containerWithNotFoundMessage("Desculpe! Não encontrei ninguém cadastrado neste time :(");
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount:
            widget._doormanListLocal.length + widget._guardListLocal.length,
        itemBuilder: guardItemBuiler,
      );
    }
  }

  //ItemBuilder
  Widget guardItemBuiler(BuildContext context, int index) {
    if (widget._doormanListLocal.length != 0 &&
        index <= (widget._doormanListLocal.length - 1)) {
      if (index == 0) {
        if (widget._guardListLocal.length == 0 &&
            widget._doormanListLocal.length == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: _hasSelectAllOptionOnDoormans,
                  child: selectAllOption()),
              TitleBuilder(
                  title: "PORTEIROS", padding: EdgeInsets.only(bottom: 5)),
              guardCardBuilder(widget._doormanListLocal.elementAt(index)),
              Container(
                width: _size.width,
                child: buttonBuilder(),
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: _hasSelectAllOptionOnDoormans,
                  child: selectAllOption()),
              TitleBuilder(
                  title: "PORTEIROS", padding: EdgeInsets.only(bottom: 5)),
              guardCardBuilder(widget._doormanListLocal.elementAt(index))
            ],
          );
        }
      } else if (widget._guardListLocal.length == 0 &&
          index == (widget._doormanListLocal.length - 1)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            guardCardBuilder(widget._doormanListLocal.elementAt(index)),
            Container(
              width: _size.width,
              child: buttonBuilder(),
            ),
          ],
        );
      } else {
        return guardCardBuilder(widget._doormanListLocal.elementAt(index));
      }
    } else if (widget._guardListLocal.length != 0 &&
        index > (widget._doormanListLocal.length - 1)) {
      if (index == widget._doormanListLocal.length) {
        if (widget._guardListLocal.length == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: _hasSelectAllOptionOnGuards,
                  child: selectAllOption()),
              TitleBuilder(
                  title: "VIGILANTES",
                  padding: EdgeInsets.only(bottom: 5, top: 20)),
              guardCardBuilder(widget._guardListLocal
                  .elementAt(index - widget._doormanListLocal.length)),
              Container(
                width: _size.width,
                child: buttonBuilder(),
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: _hasSelectAllOptionOnGuards,
                  child: selectAllOption()),
              TitleBuilder(
                  title: "VIGILANTES",
                  padding: EdgeInsets.only(bottom: 5, top: 20)),
              guardCardBuilder(widget._guardListLocal
                  .elementAt(index - widget._doormanListLocal.length))
            ],
          );
        }
      } else if (index ==
          widget._guardListLocal.length + widget._doormanListLocal.length - 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            guardCardBuilder(widget._guardListLocal
                .elementAt(index - widget._doormanListLocal.length)),
            Container(
              width: _size.width,
              child: buttonBuilder(),
            )
          ],
        );
      } else {
        return guardCardBuilder(widget._guardListLocal
            .elementAt(index - widget._doormanListLocal.length));
      }
    } else {
      return containerWithErrorMessage("");
    }
  }

  void updateSelectAllCheckBoxStatus(){
    //LOAD ISALLSELECTED INFO
    bool _isAtLeastOneSelectedInList = false;
    bool _isAllCheckedInList = true;

    widget._guardListLocal.forEach((element) {
      bool contains = false;
      _selectedGuards.forEach((elementSelected) {
        if (elementSelected.id == element.id) contains = true;
      });

      if (contains) {
        _isAtLeastOneSelectedInList = true;
      } else {
        _isAllCheckedInList = false;
      }
    });

    widget._doormanListLocal.forEach((element) {
      bool contains = false;
      _selectedGuards.forEach((elementSelected) {
        if (elementSelected.id == element.id) contains = true;
      });

      if (contains) {
        _isAtLeastOneSelectedInList = true;
      } else {
        _isAllCheckedInList = false;
      }
    });

    if (_isAtLeastOneSelectedInList) _isAllSelected = 1;

    if (_isAllCheckedInList) _isAllSelected = 2;
  }

  Widget guardCardBuilder(Guard guard) {
    bool isChecked = false;
    _selectedGuards.forEach((element) {
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
            cpf: guard.matricula,
            isChecked: isChecked,
            checkFunction:
                (int id, bool isChecked, String name, int type, String matricula) {
              Guard guard = new Guard(id: id, name: name, type: type, matricula: matricula);
              if (isChecked) {
                _selectedGuards.add(guard);
              } else {
                _selectedGuards.removeWhere((element) => element.id == guard.id);
              }
              setState(() {
                _isAllSelected = 0;
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
        labelText: "Prosseguir",
        onPressedFunction: () {
          print(_selectedGuards.toString());
          List<Guard> singletonSelectedGuards = new List();
          List<Guard> singletonSelectedDoormans = new List();
          _selectedGuards.forEach((element) {
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
            icon: Icon(_isAllSelected == 0
                ? Icons.check_box_outline_blank
                : _isAllSelected == 1
                    ? Icons.indeterminate_check_box_outlined
                    : Icons.check_box_outlined),
            onPressed: () {
              setState(() {
                if (_isAllSelected == 2) {
                  _isAllSelected = 0;
                } else {
                  _isAllSelected = 2;
                }
                if (_isAllSelected == 2) {
                  widget._guardListLocal.forEach((element) {
                    bool flag = false;
                    _selectedGuards.forEach((elementSelected) {
                      if (elementSelected.id == element.id) {
                        flag = true;
                      }
                    });
                    if (flag == false) {
                      _selectedGuards.add(element);
                    }
                  });
                  widget._doormanListLocal.forEach((element) {
                    bool flag = false;
                    _selectedGuards.forEach((elementSelected) {
                      if (elementSelected.id == element.id) {
                        flag = true;
                      }
                    });
                    if (flag == false) {
                      _selectedGuards.add(element);
                    }
                  });
                } else {
                  widget._guardListLocal.forEach((element) {
                    Guard guardToDelete = new Guard();
                    _selectedGuards.forEach((elementSelected) {
                      if (elementSelected.id == element.id)
                        guardToDelete = elementSelected;
                    });
                    _selectedGuards.remove(guardToDelete);
                  });

                  widget._doormanListLocal.forEach((element) {
                    Guard guardToDelete = new Guard();
                    _selectedGuards.forEach((elementSelected) {
                      if (elementSelected.id == element.id)
                        guardToDelete = elementSelected;
                    });
                    _selectedGuards.remove(guardToDelete);
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

//Future
var _GuardStream = FirebaseFirestore.instance
    .collection("guards")
    .where('visible', isEqualTo: true)
    .orderBy('name')
    .get();
