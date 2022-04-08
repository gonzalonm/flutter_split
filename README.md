This package contains a wrapper of [Split.io](https://docs.split.io/reference/introduction). This is an UNOFFICIAL pub for Flutter. 

## Usage
To use this plugin, add split_view as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Create Split
Create a Split in your organization given a traffic type. ([see more](https://docs.split.io/reference/create-split))
```dart
final mySplit = await splitApi.createSplit(name: 'your_split_name');
print('Created split: ${mySplit.toString()}');
```

### Get Split
Retrieves the Split. ([see more](https://docs.split.io/reference/get-split))
```dart
final split = await splitApi.getSplit(name: 'your_split_name');
print(split.toString());
```

### Delete Split
Delete a Split from your organization. This will automatically unconfigure the Split Definition from all environments. ([see more](https://docs.split.io/reference/delete-split))
```dart
await splitApi.deleteSplit(name: 'your_split_name');
```

### List Split Definitions
Retrieves the Split Definitions given an environment. ([see more](https://docs.split.io/reference/lists-split-definitions-in-environment))
```dart
final splitDefinitionList = splitApi.getSplitDefinitionList();
print(splitDefinitionList);
```
### List Split Names
Retrieves the Splits for an organization. ([see more](https://docs.split.io/reference/list-splits))
```dart
final splitNames = splitApi.listSplitsName();
print(splitNames);
```

### Get Split Definition
Retrieves a Split Definition given the name and the environment. ([see more](https://docs.split.io/reference/get-split-definition-in-environments))
```dart
final mySplitDefinition = splitApi.getSplitDefinition('your_split_name');
print(mySplitDefinition);
```