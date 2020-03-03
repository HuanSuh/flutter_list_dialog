import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../flutter_list_dialog.dart';
import 'controller/dialog_item_notifier.dart';

typedef DialogWidgetBuilder<T> = Widget Function(List<T> selected);
typedef ActionBuilder<T> = List<Widget> Function(List<T> selected);

class ListDialog<T> extends AlertDialog {
  static const String _TAG = '[flutter_list_dialog]';

  static BuildContext _context;
  static void pop() {
    try {
      Navigator.of(ListDialog._context).pop(
        Provider.of<DialogItemNotifier>(ListDialog._context, listen: false)
            .selectedValues,
      );
      ListDialog._context = null;
    } catch (e) {
      String msg = '$_TAG $e';
      debugPrint(msg);
      throw Exception(msg);
    }
  }

  final List<DialogItem<T>> items;
  final double maxHeight;
  final IndexedWidgetBuilder separatorBuilder;
  final DialogWidgetBuilder<T> headerWidgetBuilder;
  final DialogWidgetBuilder<T> footerWidgetBuilder;
  final ActionBuilder<T> actionBuilder;

  const ListDialog({
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
    EdgeInsetsGeometry contentPadding,
    Color backgroundColor,
    double elevation,
    String semanticLabel,
    ShapeBorder shape,
  })  : this.items = items,
        this.maxHeight = maxHeight,
        this.separatorBuilder = separatorBuilder,
        this.headerWidgetBuilder = headerWidgetBuilder,
        this.footerWidgetBuilder = footerWidgetBuilder,
        this.actionBuilder = actionBuilder,
        super(
          key: key,
          title: title,
          titlePadding: titlePadding ?? const EdgeInsets.all(8.0),
          titleTextStyle: titleTextStyle,
          contentTextStyle: contentTextStyle,
          contentPadding: contentPadding ?? const EdgeInsets.all(0.0),
          actions: actions,
          backgroundColor: backgroundColor,
          elevation: elevation,
          semanticLabel: semanticLabel,
          shape: shape,
        );

  bool get _hasHeader => title != null || headerWidgetBuilder != null;
  bool get _hasFooter =>
      actions?.isNotEmpty == true ||
      footerWidgetBuilder != null ||
      actionBuilder != null;

  Widget get content {
    return ChangeNotifierProvider<DialogItemNotifier>(
      create: (_) => DialogItemNotifier<T>(),
      child: Consumer<DialogItemNotifier>(
        builder: (ctx, notifier, __) {
          ListDialog._context = ctx;
          double maxHeight =
              this.maxHeight ?? MediaQuery.of(ctx).size.height * 0.5;
          return Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                headerWidgetBuilder != null
                    ? Container(
                        width: double.infinity,
                        child: headerWidgetBuilder(notifier.selectedValue),
                      )
                    : Container(),
                _hasHeader ? Divider(height: 1, thickness: 1) : Container(),
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        items.length,
                        (idx) {
                          return Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  bool preventPop;
                                  if (items[idx]?.onItemSelected != null) {
                                    preventPop = await items[idx]
                                        .onItemSelected(items[idx]);
                                  }
                                  internalOnTap(
                                      notifier, items[idx], preventPop);
                                },
                                child: Container(
                                  width: double.infinity,
                                  child: buildChild(items[idx]),
                                ),
                              ),
                              (idx < items.length - 1)
                                  ? (separatorBuilder != null)
                                      ? separatorBuilder(ctx, idx)
                                      : const Divider(
                                          indent: 4.0,
                                          endIndent: 4.0,
                                          height: 0,
                                        )
                                  : Container(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                _hasFooter ? Divider(height: 1, thickness: 1) : Container(),
                footerWidgetBuilder != null
                    ? footerWidgetBuilder(notifier.selectedValues)
                    : Container(),
                actionBuilder != null
                    ? ButtonBar(
                        children: actionBuilder(notifier.selectedValues))
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildChild(DialogItem<T> item) {
    return item.build(false);
  }

  void internalOnTap(
    DialogItemNotifier notifier,
    DialogItem<T> item,
    bool preventPop,
  ) {
    if (preventPop == true) return;
    notifier.select(item);
    ListDialog.pop();
  }
}
