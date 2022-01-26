This package contains a wrapper of Split API. This is an UNOFFICIAL pub for Flutter. 

## Using

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