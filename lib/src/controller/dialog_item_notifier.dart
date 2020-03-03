import 'package:flutter/material.dart';

import '../model/list_dialog_item.dart';

class DialogItemNotifier<T> extends ChangeNotifier {
  final List<DialogItem<T>> _selected = [];

  DialogItemNotifier([List<DialogItem<T>> selected]) {
    _selected.clear();
    _selected.addAll(
        selected?.where((item) => item.isSelected == true)?.toList() ?? []);
  }

  List<DialogItem<T>> get selected =>
      _selected..removeWhere((item) => item == null);
  T get selectedValue => selected.length == 1 ? selected[0].value : null;
  List<T> get selectedValues => selected.map<T>((item) => item.value).toList();

  void add(DialogItem<T> dialogItem) {
    if (!_selected.contains(dialogItem)) {
      _selected.add(dialogItem);
      notifyListeners();
    }
  }

  void remove(DialogItem<T> dialogItem) {
    _selected.removeWhere((item) => item == dialogItem);
    notifyListeners();
  }

  void select(DialogItem<T> dialogItem, {bool notify = false}) {
    _selected.clear();
    _selected.add(dialogItem);
    if (notify) {
      notifyListeners();
    }
  }

  void toggle(DialogItem dialogItem) {
    dialogItem.isSelected = !dialogItem.isSelected;
    if (dialogItem.isSelected) {
      add(dialogItem);
    } else {
      remove(dialogItem);
    }
  }

  bool contains(DialogItem dialogItem) => selected.contains(dialogItem);
}
