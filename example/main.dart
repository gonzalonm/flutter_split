import 'package:flutter_split/flutter_split.dart';

void main(List<String> arguments) async {
  final splitApi = SplitAPI(
      workspaceId: 'YOUR_WORKSPACE_ID',
      environmentIdOrName: 'YOUR_ENVIRONMENT_ID',
      apiKey: 'YOUR_API_KEY');

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
      await splitApi.getSplitDefinition('split_name');
  print(mySplitDefinition.toString());
}
