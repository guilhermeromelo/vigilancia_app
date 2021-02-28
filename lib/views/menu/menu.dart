import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigilancia_app/controllers/guard/guardDAO.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/login/singletonLogin.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Size get _size => MediaQuery.of(context).size;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InternalHeader(
      bottomSheet: Container(
        color: AppColors.menuGrey,
        height: 75,
        child: Column(
          children: [
            Image.asset(
              "assets/logo_nome_azul.png",
              width: 120,
            ),
            Padding(padding: EdgeInsets.only(top:5), child: Text("By Guilherme R. Melo", style: TextStyle(fontSize: 16,color: AppColors.mainBlue),),)
          ],
        ),
        alignment: Alignment.center,
      ),
      title: "Vigilância App",
      leftIcon: null,
      leftIconFunction: null,
      rightIcon1: Icons.logout,
      rightIcon1Function: (){
        _clearSharedPreferences();
        Navigator.pushReplacementNamed(context, 'login');
      },
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

  Future<void> _clearSharedPreferences() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("matricula", "0");
      prefs.setString("senha", "0");
    });
  }

  //LISTA DE ICONES DA HOME.
  Widget widgetBotoesInicio() {
    bool boolMobile = _size.width < _size.height;
    return Wrap(
      direction: SingletonLogin().loggedUser.type == 0 ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: boolMobile ? _size.width * .1 : _size.width * .05,
      spacing: boolMobile ? _size.width * .1 : _size.width * .1,
      // runSpacing: size.height * 0.02,
      // spacing: 20,
      children: SingletonLogin().loggedUser.type == 0 ? <Widget>[
        botaoInicio(
          colorButton: Colors.white,
          textButton: "Escala",
          fncOnPressed: () async {
            Navigator.pushNamed(context, 'schedule/schedulePage');
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
      ] : <Widget>[
        botaoInicio(
          colorButton: Colors.white,
          textButton: "Escala",
          fncOnPressed: () async {
            Navigator.pushNamed(context, 'schedule/schedulePage');
          },
          iconButton: Icons.pending_actions,
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
