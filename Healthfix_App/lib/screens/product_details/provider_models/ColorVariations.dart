import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';

import '../../../size_config.dart';

class ColorvariantsBuilder extends StatefulWidget {
  final List colors;
  final bool selectable; // Will be selectable when Size is Selected
  final Function setColor;
  final num selectedIndex;

  ColorvariantsBuilder({
    Key key,
    this.colors,
    this.selectable,
    this.setColor,
    this.selectedIndex,
  }) : super(key: key);

  @override
  State<ColorvariantsBuilder> createState() => _ColorvariantsBuilderState();
}

class _ColorvariantsBuilderState extends State<ColorvariantsBuilder> {
  num _selectedIndex;
  // List _colorsDup;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    print("Index $_selectedIndex");
    super.initState();
  }

  @override
  void dispose() {
    _selectedIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex ??= widget.selectedIndex;
    print("Index $_selectedIndex");

    List _colors = widget.colors;
    // if (_colors != _colorsDup) _selectedIndex = widget.selectedIndex;
    // _colorsDup = _colors;

    // print("${_colors} ${_colorsDup}");
    // print(_colors);
    // _selectedIndex = null;

    // print(int.parse("0xFF" + _colors[0]));
    return Container(
      child: Row(
        children: [
          for (var i = 0; i < _colors.length; i++)
            GestureDetector(
              onTap: () {
                print(i);
                if (widget.selectable) {
                  setState(() {
                    print("color ${_colors[i]} $_selectedIndex $i");
                    _selectedIndex = i;
                    print("$i $_selectedIndex");
                    widget.setColor(_colors[i]);
                  });
                }
              },
              child: Container(
                height: getProportionateScreenWidth(30),
                width: getProportionateScreenWidth(30),
                margin: EdgeInsets.only(
                  right: getProportionateScreenHeight(12),
                  // top: getProportionateScreenWidth(18),
                  // bottom: getProportionateScreenWidth(18),
                ),
                child: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                      color: Color(int.parse("0xFF" + _colors[i]["hex"])).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(
                        getProportionateScreenWidth(20),
                      ),
                      border:
                          Border.all(color: Colors.white, width: (_selectedIndex == i && widget.selectable) ? 1 : 0.2),
                      // border: _selectedIndex == i && widget.selectable
                      //     ? Border.all(color: kPrimaryColor, width: 1)
                      //     : _colors[i]["hex"].toLowerCase() == ("ffffffff")
                      //         ? Border.all(color: kPrimaryColor, width: 0.2)
                      //         : null,
                    )),
                    Visibility(
                      visible: _selectedIndex == i && widget.selectable,
                      child: Center(
                        child: Icon(
                          Icons.done_rounded,
                          color: Colors.white,
                          size: getProportionateScreenHeight(20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
