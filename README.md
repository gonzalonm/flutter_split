This package contains a wrapper of [Split.io](https://docs.split.io/docs). This is an UNOFFICIAL pub for Flutter. 

## Usage
To use this plugin, add split_view as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Example

```dart
// List split definitions
final splitDefinitionList = splitApi.getSplitDefinitionList();
print(splitDefinitionList);

// List split names
final splitNames = splitApi.listSplitsName();
print(splitNames);

// Retrieve split definition given split name.
final mySplitDefinition = splitApi.getSplitDefinition('split_name');
print(mySplitDefinition);
```