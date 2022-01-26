import 'package:flutter_split/flutter_split.dart';

void main(List<String> arguments) async {
  final splitApi = SplitAPI(
      workspaceId: 'YOUR_WORKSPACE_ID',
      environmentIdOrName: 'YOUR_ENVIRONMENT_ID_OR_NAME',
      apiKey: 'YOUR_API_KEY');

  // List split definitions
  final splitDefinitionList = splitApi.getSplitDefinitionList();
  print(splitDefinitionList);

  // List split names
  final splitNames = splitApi.listSplitsName();
  print(splitNames);

  // Retrieve split definition given split name.
  final mySplitDefinition = splitApi.getSplitDefinition('split_name');
  print(mySplitDefinition);
}
