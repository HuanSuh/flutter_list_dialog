import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// if returns false, prevent pop in ListDialog
typedef OnItemSelected<ListDialogItem> = Future<bool> Function(
    ListDialogItem item);

class DialogItem<T> {
  final Widget child;
  final T value;
  final OnItemSelected onItemSelected;
  bool isSelected;

  DialogItem({
    @required this.child,
    @required this.value,
    this.onItemSelected,
    bool isSelected,
  })  : assert(value != null),
        this.isSelected = false;

  Widget build(bool hasSelectBox) => child;

  @override
  String toString() {
    return 'DialogItem{value: $value}';
  }
}
