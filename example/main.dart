import 'package:flutter_split/flutter_split.dart';

void main(List<String> arguments) async {
  final splitApi = SplitAPI(
      workspaceId: '17ce8460-7bda-11ec-af45-1699d15ca5a6',
      environmentIdOrName: '17e36bf0-7bda-11ec-af45-1699d15ca5a6',
      apiKey: 'bka80mh5sfuhjptla6o0s6d0gsgravg04uio');

  // List split definitions
  print('List split definitions');
  final splitDefinitionList = await splitApi.getSplitDefinitionList();
  for (var element in splitDefinitionList) {
    print(element.toJson());
  }

  // List split names
  print('List split names');
  final splitNames = await splitApi.listSplitsName();
  print(splitNames);

  // Retrieve split definition given split name.
  print('Retrieve split definition given split name.');
  final mySplitDefinition =
      await splitApi.getSplitDefinition('mailchimp_subscription');
  print(mySplitDefinition.toString());
}
