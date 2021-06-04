import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/user/userDAO.dart';
import 'package:vigilancia_app/models/user/user.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/components/popup/popup.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/constants/masks.dart';
import 'package:vigilancia_app/views/user/singletonUser.dart';

String _name = "";
String _matricula = "";
String _senha = "";
bool _obscureText = true;

class UserRegistrationPage extends StatefulWidget {
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  @override
  void initState() {
    // TODO: implement initState
    if (SingletonUser().isUpdate) {
      _name = SingletonUser().user.name;
      _matricula = SingletonUser().user.matricula;
      _senha = "";
    } else {
      _name = "";
      _matricula = "";
      _senha = "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InternalHeaderWithTabBar(
      initialIndex: SingletonUser().isUpdate ? SingletonUser().user.type : 0,
      tabQuantity_x2_or_x3: 2,
      text1: "Administrador",
      text2: "Líder Equipe",
      title: SingletonUser().isUpdate ? "Editar Usuário" : "Novo Usuário",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      rightIcon1: SingletonUser().isUpdate ? Icons.delete : null,
      rightIcon1Function: SingletonUser().isUpdate
          ? () {
              if (SingletonUser().isUpdate) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PopUpYesOrNo(
                      title: 'Deletar Usuário',
                      text: 'Deseja realmente deletar este usuário?',
                      onYesPressed: () async {
                        SingletonUser().currentIndexForUserListPage =
                            SingletonUser().user.type;
                        await deleteUser(SingletonUser().user.id, context);
                        await Navigator.popUntil(
                            context, ModalRoute.withName('menu'));
                        Navigator.pushNamed(context, 'user/list');
                      },
                      onNoPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              }
            }
          : null,
      widget1: UserRegistrationSubPage(
        index: 0,
      ),
      widget2: UserRegistrationSubPage(
        index: 1,
      ),
    );
  }
}

class UserRegistrationSubPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  int index;

  UserRegistrationSubPage({Key key, this.index}) : super(key: key);

  @override
  _UserRegistrationSubPageState createState() =>
      _UserRegistrationSubPageState();
}

class _UserRegistrationSubPageState extends State<UserRegistrationSubPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: widget._formKey,
      child: ListView(
        children: [
          AppTextFormField(
            initialValue: _name,
            labelText: "Nome",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text) {
              _name = text;
            },
          ),
          AppTextFormField(
            keyboardInputType: TextInputType.number,
            initialValue: _matricula,
            labelText: "Matrícula",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text) {
              _matricula = text;
            },
          ),
          AppTextFormField(
            textCapitalization: TextCapitalization.none,
            suffixIcon: _obscureText ? Icons.visibility : Icons.visibility_off,
            suffixIconOnPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            obscureText: _obscureText,
            initialValue: _senha,
            labelText: "Senha",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (SingletonUser().isUpdate == false) {
                if (text.isEmpty) return "Campo Vazio";
              }
            },
            onChangedFunction: (text) {
              _senha = text;
            },
          ),
          Visibility(
              visible: SingletonUser().isUpdate,
              child: Container(
                width: size.width,
                padding: EdgeInsets.only(right: 10, left: 10, top: 5),
                child: Row(
                  children: [
                    Text(
                      "Atenção: ",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    Expanded(
                        child: Text(
                      "Caso NÃO deseje alterar a senha, deixe em branco",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ))
                  ],
                ),
              )),
          AppButton(
            labelText:
                SingletonUser().isUpdate == false ? "Cadastrar" : "Atualizar",
            onPressedFunction: () async {
              if (widget._formKey.currentState.validate()) {
                var bytes = utf8.encode(_senha); // data being hashed
                var digest = sha1.convert(bytes);

                User newUser = User(
                    id: SingletonUser().isUpdate ? SingletonUser().user.id : 0,
                    name: _name,
                    matricula: _matricula,
                    type: widget.index,
                    senha: digest.toString());
                if (SingletonUser().isUpdate) {
                  if (_senha.isEmpty) {
                    await updateUserWithoutPassword(newUser, context);
                  } else {
                    await updateUserWithPassword(newUser, context);
                  }
                } else {
                  await addUser(newUser, context);
                }

                await Navigator.popUntil(context, ModalRoute.withName('menu'));
                Navigator.pushNamed(context, 'user/list');
              }
            },
          ),
        ],
      ),
    );
  }
}
