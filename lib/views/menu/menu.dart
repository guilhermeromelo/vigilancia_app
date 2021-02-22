import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vigilancia_app/controllers/guard/guardDAO.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
        centerTitle: true,
        backgroundColor: AppColors.mainBlue,
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: AppColors.menuGrey,
              width: _size.width,
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widgetBotoesInicio(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //LISTA DE ICONES DA HOME.
  Widget widgetBotoesInicio() {
    bool boolMobile = _size.width < _size.height;
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: boolMobile ? _size.width * .1 : _size.width * .05,
      spacing: boolMobile ? _size.width * .1 : _size.width * .1,
      // runSpacing: size.height * 0.02,
      // spacing: 20,
      children: <Widget>[
        botaoInicio(
          colorButton: Colors.white,
          textButton: "Escala",
          fncOnPressed: () async {
            Navigator.pushNamed(context, 'schedule/schedulePage');

            //Guard guard = Guard(cpf: "111.111.111-11", type: 1, name: "Nome111", id: 2);
            //deleteGuard(guard, context);
          },
          iconButton: Icons.pending_actions,
        ),
        botaoInicio(
          colorButton: Colors.white,
          textButton: "Usuários",
          fncOnPressed: () {
            Navigator.pushNamed(context, 'user/list');
          },
          iconButton: Icons.person,
        ),
        botaoInicio(
          colorButton: Colors.white,
          textButton: "Postos de Trabalho",
          fncOnPressed: () {
            Navigator.pushNamed(context, 'workplace/list');
          },
          iconButton: Icons.wb_shade,
        ),
        botaoInicio(
          colorButton: Colors.white,
          textButton: "Porteiros e Vigilantes",
          fncOnPressed: () {
            Navigator.pushNamed(context, 'guard/list');
          },
          iconButton: Icons.admin_panel_settings,
        ),
      ],
    );
  }

  //CRIANDO O BOTÃO DA HOME.
  Widget botaoInicio({
    @required Color colorButton,
    @required String textButton,
    @required Function fncOnPressed,
    @required IconData iconButton,
  }) {
    bool boolMobile = _size.width < _size.height;
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: boolMobile ? _size.width * .35 : _size.width * .15,
      height: boolMobile ? _size.width * .35 : _size.width * .15,
      decoration: BoxDecoration(
        color: colorButton,
        borderRadius: BorderRadius.circular(5),
      ),
      child: FlatButton(
        onPressed: fncOnPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Icon(
                iconButton,
                size: boolMobile ? _size.width * .12 : _size.width * .05,
                color: AppColors.mainBlue,
              ),
            ),
            Text(
              textButton,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.mainBlue,
                fontSize: boolMobile ? _size.width * .046 : _size.width * .019,
              ),
            )
          ],
        ),
      ),
    );
  }
}
