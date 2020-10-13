import 'package:flutter/material.dart';


Widget productTextField(
    {String textTitle,
      String textHint,
      double height,
      TextEditingController controller,
      TextInputType textType,int maxLine}) {
  textHint == null ? textHint = "Enter Hint" : textHint;
  textTitle == null ? textTitle = "Enter Title" : textTitle;

  height == null ? height = 50.0 : height;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          textTitle,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: TextField(
              controller: controller,
              keyboardType: textType == null ? TextInputType.text : textType,maxLines: maxLine==null?null:maxLine,
              decoration:
              InputDecoration(border: InputBorder.none, hintText: textHint),
            ),
          ),
        ),
      ),
    ],
  );
}