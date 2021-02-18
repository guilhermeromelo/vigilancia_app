import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

class ContSpinner extends StatefulWidget {
  Function onChangeFunction;
  int initialValue;
  int originalValue;

  ContSpinner({Key key, this.initialValue = 0, this.onChangeFunction, this.originalValue})
      : super(key: key);

  @override
  _ContSpinnerState createState() => _ContSpinnerState();
}

class _ContSpinnerState extends State<ContSpinner> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.text = widget.initialValue.toString();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
          color: Colors.black),
      width: 150,
      height: 40,
      child: Row(
        children: [
          Expanded(
            flex: 30,
            child: IconButton(
              icon: Icon(
                Icons.remove,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if(widget.initialValue>0){
                    widget.initialValue--;
                    widget.onChangeFunction(widget.initialValue.toString());
                  }
                });
              },
            ),
          ),
          Expanded(
              flex: 36,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.white,
                  ),
                  TextField(
                    enabled: false,
                    onTap: () {
                      controller.clear();
                    },style: TextStyle(color: (widget.originalValue != null && widget.originalValue != widget.initialValue) ? Colors.deepOrange : AppColors.mainBlue, fontWeight: FontWeight.bold, fontSize: 22,),
                    onSubmitted: (String text){
                      if(text.contains(" ") || text.contains("-") || text == ""){
                        widget.initialValue = 0;
                        widget.onChangeFunction("0");
                      }
                      widget.initialValue = int.parse(text);
                      FocusScope.of(context).requestFocus(new FocusNode());
                      widget.onChangeFunction(text);
                  },
                    onChanged: (String text) {
                      if(text == ""){
                        widget.initialValue = 0;
                        widget.onChangeFunction("0");
                      }else{
                        widget.initialValue = int.parse(text);
                        widget.onChangeFunction(text);
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    controller: controller,
                  )
                ],
              )),
          Expanded(
            flex: 30,
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  widget.initialValue++;
                  widget.onChangeFunction(widget.initialValue.toString());
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

