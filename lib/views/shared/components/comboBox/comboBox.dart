import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';

/*
Arquivo referente ao componente de comboBox sem o modo de pesquisa integrado.

  Necessita receber obrigatório como parâmetro o tipo de dado que será exibido e a Lista destes dados.
    type é do tipo String
    objects é do tipo List
    onTapFunction é a função que irá recuperar o item selecionado

  Ex:
  ComboBox(
    type: "Cliente",
    objects: [
      "bugWare",
      "IFTM",
      "Empresa Júnior",
      "Av Dr Florestan Fernandes, 131 - Sala 110",
    ],
    onTapFunction: getItem,
  )

  void getItem(String text){
    print(text);
  }
*/

class ComboBox extends StatefulWidget {
  @required
  final String title;
  List objects;
  Function onTapFunction;
  String currentObject;
  EdgeInsets paddingExterno;
  Function validatorFunction;

  TextEditingController _controller = TextEditingController();

  ComboBox(
      {Key key,
      this.title,
      this.objects,
      this.onTapFunction,
      this.currentObject,
      this.paddingExterno,
      this.validatorFunction})
      : super(key: key);

  final borderProps = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
  );

  @override
  _ComboBoxState createState() => _ComboBoxState();
}

class _ComboBoxState extends State<ComboBox> {
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  int line = 1;
  TextOverflow overflow = TextOverflow.ellipsis;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems(line, overflow);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(
      int line, TextOverflow overflow) {
    List<DropdownMenuItem<String>> items = new List();
    for (String object in widget.objects) {
      items.add(
        new DropdownMenuItem(
          value: object,
          child: new Text(
            object,
            style: TextStyle(fontSize: 18.0),
            overflow: overflow,
            maxLines: line,
            softWrap: true,
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleBuilder(
            padding: EdgeInsets.only(bottom: 5), title: widget.title),
      TextFormField(
      validator: widget.validatorFunction,
      controller: widget._controller,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(

          suffixIcon: DropdownButtonHideUnderline(
              child: Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 10),
                  child: DropdownButton(
                    hint: Text("Selecionar...",maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.mainBlue,
                        fontSize: 20,
                      ),),
                    value: widget.currentObject,
                    items: _dropDownMenuItems,
                    onChanged: (String text){
                      FocusScope.of(context).requestFocus(new FocusNode());
                      changedItem(text);
                    },
                    iconEnabledColor: AppColors.mainBlue,
                    isExpanded: true,
                    //isDense: true,
                  ))),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.fromLTRB(25, 10, 25, 10),
          errorStyle: TextStyle(
            fontSize: 16,
          )),
    ),
      ],
    );
  }

  void changedItem(String selectedObject) {
    setState(() {
      widget.onTapFunction(selectedObject);
      widget.currentObject = selectedObject;
    });
  }
}
