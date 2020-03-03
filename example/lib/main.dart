import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_dialog/flutter_list_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => MyPage());
      },
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_listed_dialog'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
        child: Column(
          children: <Widget>[
            // List dialog
            _buildTitle(context, 'List dialog'),
            _buildExample(
              context,
              'TextItem',
              (ctx) => ListDialog(
                items: ExampleBuilder._items
                    .map((item) => DialogTextItem(item.text))
                    .toList(), // List<ListDialogTextItem>
              ),
            ),
            _buildExample(
              context,
              'with title and header',
              (ctx) => ListDialog(
//                title: Text('Title'),
                headerWidgetBuilder: (_) => Text('Select your favorite color.'),
                footerWidgetBuilder: (_) => Text('AH'),
                items: ExampleBuilder._items
                    .map((item) => DialogTextItem(item.text))
                    .toList(), // List<ListDialogTextItem>
              ),
            ),
            _buildExample(
              context,
              'Alignment.left',
              (ctx) => ListDialog(
                items: ExampleBuilder._items
                    .map(
                      (item) => DialogTextItem(
                        item.text,
                        alignment: Alignment.centerLeft,
                      ),
                    )
                    .toList(), // List<ListDialogTextItem>
              ),
            ),
            _buildExample(
              context,
              'scroll',
              (ctx) => ListDialog(
//                title: Text('Title'),
//                titlePadding: const EdgeInsets.all(10),
                maxHeight: MediaQuery.of(context).size.height * 0.2,
//                actions: <Widget>[
//                  FlatButton(
//                    child: Text('Confirm'),
//                    onPressed: () {},
//                  )
//                ],
                items: ExampleBuilder._items
                    .map((item) => DialogTextItem(item.text))
                    .toList(), // List<ListDialogTextItem>
              ),
            ),
            _buildExample(
              context,
              'Widget',
              (ctx) => ListDialog(
                items: ExampleBuilder._items
                    .map(
                      (item) => DialogItem<String>(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                  width: 24, height: 24, color: item.color),
                            ),
                            Text(item.text),
                          ],
                        ),
                        value: item.text,
                      ),
                    )
                    .toList(),
              ),
            ),

            // Checkbox dialog
            _buildTitle(context, 'Checkbox dialog'),
            _buildExample(
              context,
              'TextItem',
              (ctx) => CheckboxListDialog(
                items: ExampleBuilder._items
                    .map((item) => DialogTextItem(item.text))
                    .toList(), // List<ListDialogTextItem>
                actions: <Widget>[
                  FlatButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      ListDialog.pop();
                    },
                  )
                ],
              ),
            ),
            _buildExample(
              context,
              'Show Checkbox dialog\n(widget)',
              (ctx) => CheckboxListDialog(
                items: ExampleBuilder._items
                    .map((item) => DialogItem(
                          child: Row(
                            children: <Widget>[
                              Text(item.text),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    width: 8, height: 8, color: item.color),
                              ),
                            ],
                          ),
                          value: item.text,
                        ))
                    .toList(),
                actionBuilder: (selected) {
                  return [
                    FlatButton(
                      child: Text('OK'),
                      onPressed: selected?.isNotEmpty == true
                          ? () {
                              Navigator.of(context).pop(selected);
                            }
                          : null,
                    )
                  ];
                },
              ),
            ),

            // Radio button dialog
            _buildTitle(context, 'RadioButton dialog'),
            _buildExample(
              context,
              'Show RadioButton dialog',
              (ctx) => RadioListDialog(
                items: ExampleBuilder._items
                    .map((item) => DialogTextItem(item.text))
                    .toList(),
                actionBuilder: (selected) {
                  return [
                    FlatButton(
                      child: Text('OK'),
                      onPressed: selected?.isNotEmpty == true
                          ? () {
                              Navigator.of(context).pop(selected);
                            }
                          : null,
                    )
                  ];
                }, // List<ListDialogTextItem>
              ),
            ),
            _buildExample(
              context,
              'Show RadioButton dialog\n(widget)',
              (ctx) => RadioListDialog(
                items: ExampleBuilder._items
                    .map((item) => DialogItem(
                          child: Row(
                            children: <Widget>[
                              Text(item.text),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    width: 8, height: 8, color: item.color),
                              ),
                            ],
                          ),
                          value: item.text,
                        ))
                    .toList(),
                actionBuilder: (selected) {
                  return [
                    FlatButton(
                      child: Text('OK'),
                      onPressed: selected?.isNotEmpty == true
                          ? () {
                              Navigator.of(context).pop(selected);
                            }
                          : null,
                    )
                  ];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(text ?? '', style: Theme.of(context).textTheme.title),
    );
  }

  Widget _buildExample(
      BuildContext context, String title, DialogBuilder dialogBuilder) {
    return RaisedButton(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onPressed: () async {
        var result = await showDialog(
          context: context,
          builder: dialogBuilder,
        );
        if (result == null) return;
        showModalBottomSheet(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('debug (selected)\n${result.toString()}'),
          ),
        );
      },
    );
  }
}

typedef DialogBuilder = AlertDialog Function(BuildContext context);

class ExampleBuilder {
  static List<TestItem> _items = [
    TestItem('Red', Colors.red),
    TestItem('Blue', Colors.blue),
    TestItem('Orange', Colors.orange),
    TestItem('Yellow', Colors.yellow),
    TestItem('Purple', Colors.purple)
  ];
}

class TestItem {
  final String text;
  final Color color;
  TestItem(this.text, this.color);
}
