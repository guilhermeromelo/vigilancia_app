import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

class GuardCard extends StatefulWidget {
  String name;
  int id;
  int type;
  String cpf;

  IconData icon;
  bool isChecked;
  Function checkFunction;

  GuardCard({Key key, this.name, this.icon, this.isChecked = false, this.id, this.checkFunction, this.type, this.cpf}) : super(key: key);

  @override
  _GuardCardState createState() => _GuardCardState();
}

class _GuardCardState extends State<GuardCard> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double widthCard = screen.width * 0.9;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      width: widthCard,
      height: 55,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 7, left: 10),
            child: Icon(
              widget.icon ?? Icons.schedule,
              size: 21,
              color: AppColors.mainBlue,
            ),
          ),
          Expanded(
              child: Text(
                widget.name ?? "",
                maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: 19),
                overflow: TextOverflow.ellipsis,
              )),
          Container(alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(widget.isChecked ? Icons.check_box_outlined : Icons.check_box_outline_blank),
              onPressed: (){
                setState(() {
                  widget.isChecked = !widget.isChecked;
                  widget.checkFunction(widget.id, widget.isChecked, widget.name, widget.type, widget.cpf);
                });
              },
            ),)
        ],
      ),
    );
  }
}
