import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/contSpinner/cont_spinner.dart';

/*
Ex:
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: WorkplaceCard(
            title: "Portaria Principal",
            line1: "Diurno",
            line2: "Porteiros",
            line3: "Vigilantes",
          ),
        )
 */

class WorkplaceEditableCard extends StatefulWidget {
  String name;
  bool isChecked = false;
  int doormanQt;
  int guardQt;
  int initialDoormanQt;
  int initialGuardQt;
  Function doormanFunction;
  Function guardFunction;
  Function checkFunction;

  WorkplaceEditableCard(
      {Key key,
      this.name,
      this.isChecked = false,
      this.guardQt,
      this.doormanQt,
      this.doormanFunction,
      this.guardFunction,
      this.checkFunction,
      this.initialDoormanQt,
      this.initialGuardQt})
      : super(key: key);

  @override
  _WorkplaceEditableCardState createState() => _WorkplaceEditableCardState();
}

class _WorkplaceEditableCardState extends State<WorkplaceEditableCard> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double widthCard = screen.width * 0.9;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      width: widthCard,
      height: 150,
      child: Column(
        children: [
          Expanded(
              flex: 29,
              child: Container(
                padding: EdgeInsets.only(left: 10),
                width: widthCard,
                alignment: Alignment.centerLeft,
                color: AppColors.mainBlue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      widget.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                    IconButton(
                        alignment: Alignment.centerRight,
                        icon: Icon(
                          widget.isChecked
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.isChecked = !widget.isChecked;
                            widget.checkFunction(widget.isChecked);
                          });
                        }),
                  ],
                ),
              )),
          Expanded(
              flex: 71,
              child: Container(
                width: widthCard,
                color: AppColors.lightBlue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Porteiros: ",
                              style: TextStyle(fontSize: 19),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: ContSpinner(
                                initialValue: widget.doormanQt,
                                originalValue: widget.initialDoormanQt,
                                onChangeFunction: (value) {
                                  widget.doormanQt = int.parse(value);
                                  widget.doormanFunction(value);
                                },
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text("Vigilantes:",
                                  style: TextStyle(fontSize: 19)),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: ContSpinner(
                                    initialValue: widget.guardQt,
                                    originalValue: widget.initialGuardQt,
                                    onChangeFunction: (value) {
                                      widget.guardQt = int.parse(value);
                                      widget.guardFunction(value);
                                    }),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
