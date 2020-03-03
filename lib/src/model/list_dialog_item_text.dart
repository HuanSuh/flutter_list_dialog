import 'package:flutter/cupertino.dart';

import 'list_dialog_item.dart';

class DialogTextItem<T> extends DialogItem<T> {
  final String text;
  final TextStyle textStyle;
  final Alignment alignment;
  final TextAlign textAlign;
  final EdgeInsets padding;

  DialogTextItem(
    this.text, {
    this.textStyle,
    this.alignment,
    this.textAlign,
    this.padding,
    T value,
    OnItemSelected onItemSelected,
    bool isSelected,
  }) : super(
          child: null,
          value: value ?? text,
          onItemSelected: onItemSelected,
          isSelected: isSelected,
        );

  @override
  Widget build(bool hasSelectBox) {
    return Padding(
      padding: padding ??
          (hasSelectBox
              ? const EdgeInsets.only(right: 12.0)
              : const EdgeInsets.all(12.0)),
      child: Container(
        alignment: alignment ??
            (hasSelectBox ? Alignment.centerLeft : Alignment.center),
        child: Text(
          text,
          style: textStyle,
          textAlign:
              textAlign ?? (hasSelectBox ? TextAlign.start : TextAlign.center),
        ),
      ),
    );
  }
}
