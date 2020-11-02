import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorpickerDialog extends StatefulWidget {
  final defaultColor;

  ColorpickerDialog({this.defaultColor});

  @override
  _ColorpickerState createState() => _ColorpickerState();
}

class _ColorpickerState extends State<ColorpickerDialog> {
  Color pickerColor;
  Color color;

  @override
  void initState() {
    super.initState();
    pickerColor = widget.defaultColor;
    color = widget.defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        color = widget.defaultColor;
        Navigator.of(context).pop(color);
        return true;
      },
      child: AlertDialog(
        title: Text("Pick a Color"),
        content: ColorPicker(
          pickerColor: pickerColor,
          paletteType: PaletteType.hsv,
          onColorChanged: (Color color) {
            setState(() {
              pickerColor = color;
            });
          },
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                color = pickerColor;
                Navigator.of(context).pop(color);
              });
            },
            child: Text(
              "Pick",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
