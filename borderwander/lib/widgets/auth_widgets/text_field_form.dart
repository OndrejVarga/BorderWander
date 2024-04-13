import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TextFieldForm extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextInputType keyboard;
  final Function onSvd;
  final obscureTxt;
  final Function validate;

  const TextFieldForm(
      this.label, this.icon, this.keyboard, this.onSvd, this.validate,
      {this.obscureTxt: false});

  @override
  _TextFieldFormState createState() => _TextFieldFormState();
}

class _TextFieldFormState extends State<TextFieldForm> {
  FocusNode _focus = new FocusNode();
  Color color = HexColor('182C25');

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  //Change color when focused on TextForms
  void _onFocusChange() {
    if (_focus.hasFocus) {
      setState(() {
        color = HexColor('455B55');
      });
    } else {
      setState(() {
        color = HexColor('182C25');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(25), color: color),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: TextFormField(
          obscureText: widget.obscureTxt,
          focusNode: _focus,
          style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
          key: ValueKey(widget.label),
          onSaved: widget.onSvd,
          validator: widget.validate,
          decoration: InputDecoration(
            icon: Icon(
              widget.icon,
              size: 30,
              color: Colors.white,
            ),
            border: InputBorder.none,
            labelStyle:
                Theme.of(context).textTheme.headline3.copyWith(fontSize: 15),
            labelText: widget.label,
          ),
        ),
      ),
    );
  }
}
