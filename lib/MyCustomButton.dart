import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCustomButton extends StatefulWidget {
  MyCustomButton(
      {Key key,
      this.buttonName,
      this.image,
      this.value,
      this.iconImage,
      this.color})
      : super(key: key);

  final String buttonName, value;
  final String image;
  final String iconImage;
  final int color;

  @override
  _MyCustomButtonState createState() => _MyCustomButtonState();
}

class _MyCustomButtonState extends State<MyCustomButton> {
  int plantHumi, plantTemp;

  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onButtonPressed(context),
      child: Opacity(
        opacity: 0.9,
        child: Container(
          width: 300,
          height: 150,
          margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4.0,
//                                spreadRadius: 5.0,
                    offset: Offset(0.0, 5.0))
              ],
              color: Color(this.widget.color),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 110, left: 15),
                child: Text(
                  this.widget.buttonName,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 190),
                width: 100,
                height: 100,
                child: Image.asset("assets/small/" + this.widget.image),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onButtonPressed(BuildContext context) {
    getData();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 350,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 180),
              child: Image(
                width: 120,
                height: 120,
                image: AssetImage(
                  "assets/big/" + this.widget.image,
                ),
              ),
            ),
            this.widget.value == "water"
                ? showButton()
                : Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      () {
                        if (this.widget.buttonName == "Temperature") {
                          return plantTemp.toString();
                        } else if (this.widget.buttonName == "Humidity") {
                          return plantHumi.toString();
                        }
                      }(),
                      style: TextStyle(
                        fontSize: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(top: 240),
              child: Text(
                this.widget.buttonName,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      backgroundColor: Color(this.widget.color),
    );
  }

  showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50, left: 5, right: 5),
              child: GestureDetector(
                onTap: () => databaseReference
                    .collection("sensor_values")
                    .document("values")
                    .updateData({"watering": true}),
                child: Container(
                  width: 130,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          offset: Offset(2.0, 2.0))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    "On",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, left: 5, right: 5),
              child: GestureDetector(
                onTap: () => databaseReference
                    .collection("sensor_values")
                    .document("values")
                    .updateData({"watering": false}),
                child: Container(
                  width: 130,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          offset: Offset(2.0, 2.0))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    "Off",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  getData() {
    setState(() {
      databaseReference
          .collection("sensor_values")
          .document("values")
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        plantTemp = documentSnapshot.data["plant_temp"];
        plantHumi = documentSnapshot.data["plant_humi"];
      });
    });
  }
}
