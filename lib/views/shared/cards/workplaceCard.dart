import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

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


class WorkplaceCard extends StatelessWidget {
  String title;
  String line1;
  String line2;
  String line3;
  IconData icon1;
  IconData icon2;
  IconData icon3;

  WorkplaceCard(
      {Key key,
      this.title,
      this.line1,
      this.line2,
      this.line3,
      this.icon1,
      this.icon2,
      this.icon3})
      : super(key: key);

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
      height: 120,
      child: Column(
        children: [
          Expanded(
            flex: 33,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              width: widthCard,
              alignment: Alignment.centerLeft,
              color: AppColors.mainBlue,
              child: Text(
                title ?? "",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Expanded(
            flex: 67,
            child: Container(
              alignment: Alignment.topLeft,
              width: widthCard,
              color: AppColors.lightBlue,
              padding: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: line1 != null,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 7),
                          child: Icon(
                            icon1 ?? Icons.schedule,
                            size: 21,
                            color: AppColors.mainBlue,
                          ),
                        ),
                        Expanded(
                            child: Text(
                          line1 ?? "",
                          maxLines: 1,
                          style: TextStyle(color: Colors.black, fontSize: 19),
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: line2 != null,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 7),
                          child: Icon(
                            icon2 ?? Icons.record_voice_over,
                            size: 21,
                            color: AppColors.mainBlue,
                          ),
                        ),
                        Expanded(
                            child: Text(
                          line2 ?? "",
                          maxLines: 1,
                          style: TextStyle(color: Colors.black, fontSize: 19),
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: line3 != null,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 7),
                            child: Icon(
                              icon3 ?? Icons.admin_panel_settings,
                              size: 21,
                              color: AppColors.mainBlue,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            line3 ?? "",
                            maxLines: 1,
                            style: TextStyle(color: Colors.black, fontSize: 19),
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
