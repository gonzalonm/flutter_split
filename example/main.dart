import 'package:flutter_split/flutter_split.dart';

void main(List<String> arguments) async {
  final splitApi = SplitAPI(
      //workspaceId:'YOUR_WORKSPACE_ID',
      //environmentIdOrName: 'YOUR_ENVIRONMENT_ID',
      //apiKey: 'YOUR_API_KEY'
      workspaceId: '17ce8460-7bda-11ec-af45-1699d15ca5a6',
      environmentIdOrName: '17e36bf0-7bda-11ec-af45-1699d15ca5a6',
      apiKey: 'bka80mh5sfuhjptla6o0s6d0gsgravg04uio');

  // await _createSplit(splitApi);

  await _getSplit(splitApi);

  //await _listSplitDefinitions(splitApi);

  //await _listSplitNames(splitApi);

  //await _retrieveSplitDefinition(splitApi);
}

Future<void> _listSplitDefinitions(SplitAPI splitApi) async {
  print('List split definitions');
  final splitDefinitionList = await splitApi.getSplitDefinitionList();
  for (var element in splitDefinitionList) {
    print(element.toJson());
  }
}

Future<void> _listSplitNames(SplitAPI splitApi) async {
  print('List split names');
  final splitNames = await splitApi.listSplitsName();
  print(splitNames);
}

Future<void> _retrieveSplitDefinition(SplitAPI splitApi) async {
  print('Retrieve split definition given split name.');
  final mySplitDefinition = await splitApi.getSplitDefinition('split_name');
  print(mySplitDefinition.toString());
}

Future<void> _createSplit(SplitAPI splitApi) async {
  print('Create new split');
  final mySplit = await splitApi.createSplit(
      name: 'my_split_${DateTime.now().millisecond}');
  print(mySplit.toString());
}

Future<void> _getSplit(SplitAPI splitApi) async {
  print('Get Split');
  final split = await splitApi.getSplit(name: 'chat');
  print(split.toString());
}
