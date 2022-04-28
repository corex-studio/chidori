## What it does

This package lets you to easily add an action bar over keyboard.

## How to use it

All you need is to wrap your app to `KeyboardActionBarWrapper` and provide `defaultActionBar` to it.

```dart
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KeyboardActionBarWrapper(
        defaultActionBar: _buildDefaultBar,
        child: const MyHomePage(),
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
```

After that just use `ActionFocusNode` instead of default `FocusNode`.

```dart
TextField(
  focusNode: ActionFocusNode(),
)
```

## Custom action bar

To use a custom action bar on a specific text field provide `customBar` to its `ActionFocusNode`.

```dart
ActionFocusNode(
  customBar: _buildCustomBar,
);

Widget _buildCustomBar(FocusNode focusNode) {
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
```

## Dismiss on tap outside

To let focus be dismissed on tap outside the keyboard set `unfocusOnTapOutside` to `true`.

```dart
ActionFocusNode(unfocusOnTapOutside: true)
```
