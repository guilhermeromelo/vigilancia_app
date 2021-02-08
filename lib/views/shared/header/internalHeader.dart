import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

/*
Autor: Guilherme Rodrigues Melo

ÍNDICE

Componente responsável por montar uma tela com appBar do Scaffold e também o corpo
 da página (body). No appBar, é responsável por criar os ícones da esquerda e direita(1 e 2)
  e o título da página. O ícone direita 2 será usado na tela de cadastro de pacotes
 que conta com botão de adicionar e histórico. Acompanha o Bottom Navigation Bar quando o
 parâmetro hasNavigationBar == true (para utilizar o Bottom Navigation Bar passe também o
 parâmetro navigationBarIndex: 0, onde 0 é o número da página selecionada - 0,1,2 ou 3)

 Para utilizar este componete, passe por parâmetro pelo menos o ícone esquerdo,
 sua função e o título da página, o corpo da tela (body) e se deseja o Bottom NavigationBar
 (hasNavigationBar == true ou hasNavigationBar == false), passe também o
 parâmetro navigationBarIndex: 0, onde 0 é o número da página selecionada - 0,1,2 ou 3).
 Opicional: passar o ícone da direita1 e sua função e/ou passar o ícone da direita2 e sua função

 Ex:
Internal_header(
    leftIcon: Icons.arrow_back_ios,
    leftIconFunction: () {
      print("função esquerdo");
    },
    rightIcon1: Icons.history,
    rightIcon1Function: () {
      print("função direito 1");
    },
    rightIcon2: Icons.add,
    rightIcon2Function: () {
      print("função direito 2");
    },
    title: "Pacotes",
    hasNavigationBar: true,
    navigationBarIndex: 2,
    body: Container());
*/

class InternalHeader extends StatelessWidget {
  @required
  final IconData leftIcon;
  @required
  final Function leftIconFunction;
  final IconData rightIcon1;
  final Function rightIcon1Function;
  final IconData rightIcon2;
  final Function rightIcon2Function;
  @required
  final String title;
  final Widget body;
  @required
  final bool hasNavigationBar;
  final int navigationBarIndex;

  const InternalHeader(
      {Key key,
        this.leftIcon,
        this.leftIconFunction,
        this.rightIcon1,
        this.rightIcon1Function,
        this.rightIcon2,
        this.rightIcon2Function,
        this.title,
        this.body,
        this.hasNavigationBar,
        this.navigationBarIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            leftIcon,
            size: 25.0,
          ),
          onPressed: leftIconFunction,
        ),
        title: Text(title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            )),
        centerTitle: true,
        backgroundColor: AppColors.mainBlue,
        actions: [
          IconButton(
              icon: Icon(
                rightIcon2 ?? null,
                size: 25.0,
              ),
              onPressed: rightIcon2Function ?? null),
          IconButton(
              icon: Icon(
                rightIcon1 ?? null,
                size: 25.0,
              ),
              onPressed: rightIcon1Function ?? null)
        ],
      ),
      body: body ?? null,
    );
  }
}
