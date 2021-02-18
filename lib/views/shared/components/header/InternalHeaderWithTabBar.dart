import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

/*
Autor: Guilherme Rodrigues Melo
ÍNDICE
Componente responsável por montar o TabBar do Scaffold (divide a tela em 2 ou 3 guias),
UTILIZAR SOMENTE 2 ou 3 GUIAS.Acompanha o Bottom Navigation Bar quando o
 parâmetro hasNavigationBar == true (para utilizar o Bottom Navigation Bar passe também o
 parâmetro navigationBarIndex: 0, onde 0 é o número da página selecionada - 0,1,2 ou 3)
 Para utilizar este componete, passe por parâmetro pelo menos o ícone esquerdo,
 sua função e o título da página, a quantidade de guias (2 ou 3), o texto e
 widget de cada guia. Se deseja o Bottom NavigationBar
 (hasNavigationBar == true ou hasNavigationBar == false), passe também o
 parâmetro navigationBarIndex: 0, onde 0 é o número da página selecionada - 0,1,2 ou 3).
 Opcional: passar o ícone da direita e sua função, passar
 a cor do indicador de guia (tracinho em baixo do nome).
 Ex:
 InternalHeaderWithTabBar(tabQuantity_x2_or_x3: 3,
    hasNavigationBar: true,
    navigationBarIndex: 2,
    leftIcon: Icons.arrow_back_ios,
    leftIconFunction: () {
      print("função esquerdo");
    },
    rightIcon1: Icons.history,
    rightIcon1Function: () {
      print("função direito1");
    },
    rightIcon2: Icons.add,
    rightIcon2Function: () {
      print("função direito2");
    },
    title: "Pacotes",
    text1: "Todos",
    widget1: new Container(
      color: Colors.redAccent,
    ),
    text2: "Coletas",
    widget2: new Container(
      color: Colors.yellowAccent,
    ),
    text3: "Entregas",
    widget3: new Container(
      color: Colors.purple,
    ),
  );
 */

class InternalHeaderWithTabBar extends StatelessWidget {
  @required
  final IconData leftIcon;
  @required
  final Function leftIconFunction;
  final IconData rightIcon1;
  final Function rightIcon1Function;
  final Color rightIcon1Color;
  final IconData rightIcon2;
  final Function rightIcon2Function;
  final Color rightIcon2Color;
  @required
  final String title;
  @required
  final String text1;
  @required
  final Widget widget1;
  @required
  final String text2;
  @required
  final Widget widget2;
  @required
  final String text3;
  @required
  final Widget widget3;
  final Color indicatorColor;
  @required
  final int tabQuantity_x2_or_x3;
  @required
  final int initialIndex;

  const InternalHeaderWithTabBar(
      {Key key,
        this.leftIcon,
        this.leftIconFunction,
        this.rightIcon1,
        this.rightIcon1Function,
        this.rightIcon1Color,
        this.rightIcon2,
        this.rightIcon2Function,
        this.rightIcon2Color,
        this.title,
        this.text1,
        this.widget1,
        this.text2,
        this.widget2,
        this.text3,
        this.widget3,
        this.tabQuantity_x2_or_x3,
        this.indicatorColor,
        this.initialIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: initialIndex ?? 0,
        length: tabQuantity_x2_or_x3 ?? 0,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                leftIcon,
                size: 25.0,
              ),
              onPressed: leftIconFunction,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.mainBlue,
            actions: [
              IconButton(
                  icon: Icon(
                    rightIcon2 ?? null,
                    size: 25.0,
                    color: rightIcon2Color ?? Colors.white,
                  ),
                  onPressed: rightIcon2Function ?? null),
              IconButton(
                  icon: Icon(
                    rightIcon1 ?? null,
                    size: 25.0,
                    color: rightIcon1Color ?? Colors.white,
                  ),
                  onPressed: rightIcon1Function ?? null)
            ],
            bottom: BottomScaffold() ?? null,
          ),
          body: BodyScaffold() ?? null,
        ));
  }

  TabBarView BodyScaffold() {
    if (tabQuantity_x2_or_x3 == 3) {
      return TabBarView(
        children: [widget1, widget2, widget3],
      );
    } else if (tabQuantity_x2_or_x3 == 2) {
      return TabBarView(
        children: [widget1, widget2],
      );
    } else
      return null;
  }

  TabBar BottomScaffold() {
    if (tabQuantity_x2_or_x3 == 3) {
      return TabBar(
        unselectedLabelColor: Colors.black.withOpacity(0.7),
        indicatorColor: indicatorColor ?? Colors.white,
        indicatorWeight: 3,
        tabs: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(text1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(text2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(text3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0)),
          )
        ],
      );
    } else if (tabQuantity_x2_or_x3 == 2) {
      return TabBar(
        unselectedLabelColor: Colors.black.withOpacity(0.7),
        indicatorColor: indicatorColor ?? Colors.white,
        indicatorWeight: 3,
        tabs: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(text1, style: TextStyle(fontSize: 20.0)),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(text2, style: TextStyle(fontSize: 20.0)),
          ),
        ],
      );
    } else
      return null;
  }
}
