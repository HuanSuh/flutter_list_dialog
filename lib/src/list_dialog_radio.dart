import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/dialog_item_notifier.dart';
import 'list_dialog.dart';
import 'model/list_dialog_item.dart';

class RadioListDialog<T> extends ListDialog<T> {
  RadioListDialog({
    @required List<DialogItem<T>> items,
    double maxHeight,
    IndexedWidgetBuilder separatorBuilder,
    DialogWidgetBuilder<T> headerWidgetBuilder,
    DialogWidgetBuilder<T> footerWidgetBuilder,
    ActionBuilder<T> actionBuilder,
    //
    Key key,
    Widget title,
    EdgeInsetsGeometry titlePadding,
    TextStyle titleTextStyle,
    List<Widget> actions,
    Widget content,
    TextStyle contentTextStyle,
    Color backgroundColor,
    double elevation,
    String semanticLabel,
    ShapeBorder shape,
  }) : super(
          items: items,
          maxHeight: maxHeight,
          separatorBuilder: separatorBuilder,
          headerWidgetBuilder: headerWidgetBuilder,
          footerWidgetBuilder: footerWidgetBuilder,
          actionBuilder: actionBuilder,
          //
          key: key,
          title: title,
          titlePadding: titlePadding,
          titleTextStyle: titleTextStyle,
          actions: actions,
          content: content,
          contentTextStyle: contentTextStyle,
          backgroundColor: backgroundColor,
          elevation: elevation,
          semanticLabel: semanticLabel,
          shape: shape,
        );

  @override
  Widget buildChild(DialogItem<T> item) {
    return Row(
      children: <Widget>[
        Consumer<DialogItemNotifier>(builder: (context, notifier, __) {
          return Radio(
            groupValue: notifier.selectedValue,
            value: item.value,
            onChanged: (v) {
              if (v == item.value) {
                notifier.select(item, notify: true);
              }
            },
          );
        }),
        Expanded(child: item.build(true)),
      ],
    );
  }

  @override
  void internalOnTap(
    DialogItemNotifier notifier,
    DialogItem<T> item,
    bool preventPop,
  ) {
    notifier.select(item, notify: true);
  }
}
