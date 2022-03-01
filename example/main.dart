import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_split/flutter_split.dart';

void main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();

  // PLEASE, USE YOUR OWN assets/.env FILE!!
  final properties =
      _parsePropertiesFile(await rootBundle.loadString('/.env_dev'));

  final splitApi = SplitAPI(
      workspaceId: properties['WORKSPACE_ID'],
      environmentIdOrName: properties['ENVIRONMENT_ID'],
      apiKey: properties['API_KEY']);

  final splitName = 'my_split_${DateTime.now().millisecondsSinceEpoch}';

  const trySplitDefinitions = false;

  await _createSplit(splitApi, splitName);

  await _getSplit(splitApi, splitName);

  if (trySplitDefinitions) {
    await _retrieveSplitDefinition(splitApi, splitName);
    await _listSplitDefinitions(splitApi);
  }

  await _deleteSplit(splitApi, splitName);

  await _listSplitNames(splitApi);
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

Future<void> _retrieveSplitDefinition(
    SplitAPI splitApi, String splitName) async {
  print('Retrieve split definition given split name.');
  final mySplitDefinition = await splitApi.getSplitDefinition(splitName);
  print(mySplitDefinition.toString());
}

Future<void> _createSplit(SplitAPI splitApi, String splitName) async {
  print('Create new split');
  final mySplit = await splitApi.createSplit(name: splitName);
  print('Created split: ${mySplit.toString()}');
}

Future<void> _deleteSplit(SplitAPI splitApi, String splitName) async {
  print('Delete split');
  await splitApi.deleteSplit(name: splitName);
  print('Deleted split :$splitName');
}

Future<void> _getSplit(SplitAPI splitApi, String splitName) async {
  print('Get Split');
  final split = await splitApi.getSplit(name: splitName);
  print(split.toString());
}

Map<String, dynamic> _parsePropertiesFile(String content) {
  final data = <String, dynamic>{};
  final list = content.split('\n');
  for (var line in list) {
    if (line.contains('=')) {
      final pair = line.split('=');
      data[pair[0]] = pair[1];
    }
  }
  return data;
}
