import 'package:chidori/chidori.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KeyboardActionBarWrapper(
        defaultActionBar: _buildDefaultBar,
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }

  Widget _buildDefaultBar(FocusNode focusNode) {
    return Container(
      height: 50,
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => focusNode.unfocus(),
        child: const Text(
          'Close',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ActionFocusNode _defaultFocusNode = ActionFocusNode();
  final ActionFocusNode _tapOutsideFocusNode = ActionFocusNode(unfocusOnTapOutside: true);
  late final ActionFocusNode _customFocusNode;

  @override
  void initState() {
    super.initState();
    _customFocusNode = ActionFocusNode(
      customBar: _buildCustomBar,
      barHeight: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text('Default'),
                    TextField(
                      focusNode: _defaultFocusNode,
                    ),
                    const SizedBox(height: 20),
                    const Text('Custom'),
                    TextField(
                      focusNode: _customFocusNode,
                    ),
                    const SizedBox(height: 20),
                    const Text('Dismiss on tap outside'),
                    TextField(
                      focusNode: _tapOutsideFocusNode,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 120,
              width: 200,
              color: Colors.lime,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBar(FocusNode focusNode) {
    _customFocusNode.barHeight = 80;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 80,
      color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            'This is custom action bar',
            style: textTheme.bodyText1!.copyWith(color: Colors.white),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => focusNode.unfocus(),
            child: Text(
              'Unfocus',
              style: textTheme.bodyText2!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
