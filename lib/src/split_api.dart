import 'dart:convert';

import 'http_client.dart';

class SplitAPI {
  static const String _baseHost = 'api.split.io';

  final _httpClient = HttpClient();

  ///
  /// Creates a new instance of SplitAPI.
  ///
  SplitAPI({String? workspaceId, String? environmentIdOrName, String? apiKey}) {
    _workspaceId = workspaceId;
    _environment = environmentIdOrName;
    _apiKey = apiKey;
  }

  String? _workspaceId;
  String? _environment;
  String? _apiKey;

  ///
  /// List Split names.
  /// https://docs.split.io/reference/list-splits
  /// 
  Future<List<String>> listSplitsName() async {
    final response = await _httpClient.doGet(
        Uri.https(_baseHost, _buildSplitsUrl()),
        headers: _buildHeaders());
    var jsonData = json.decode(response.body);
    List<dynamic> list = jsonData['objects'];
    List<String> splitNames =
        list.map((element) => element['name'] as String).toList();
    return splitNames;
  }

  ///
  /// Retrieves Split Definition list.
  /// https://docs.split.io/reference/lists-split-definitions-in-environment
  ///
  Future<List<SplitDefinition>> getSplitDefinitionList() async {
    final urlPath = _buildSplitDefinitionListUrl();
    final response =
        await _httpClient.doGet(_buildUri(urlPath), headers: _buildHeaders());
    var jsonData = json.decode(response.body);
    List<dynamic> list = jsonData['objects'];
    final splitList =
        list.map((element) => SplitDefinition.fromJson(element)).toList();
    return splitList;
  }

  ///
  /// Retrieve split definition.
  /// https://docs.split.io/reference/get-split-definition-in-environment
  /// 
  Future<SplitDefinition> getSplitDefinition(String splitName) async {
    final url = _buildSplitDefinitionUrl(splitName);
    final response =
        await _httpClient.doGet(_buildUri(url), headers: _buildHeaders());
    var jsonData = json.decode(response.body);

    return SplitDefinition.fromJson(jsonData);
  }

  String _buildSplitDefinitionListUrl() =>
      '${_buildSplitsUrl()}/environments/$_environment';

  String _buildSplitDefinitionUrl(String name) =>
      '${_buildSplitsUrl()}/$name/environments/$_environment';

  String _buildSplitsUrl() => 'internal/api/v2/splits/ws/$_workspaceId';

  Uri _buildUri(String urlPath) => Uri.https(_baseHost, urlPath);

  Map<String, String> _buildHeaders() =>
      {'Content-Type': 'application/json', 'Authorization': 'Bearer $_apiKey'};
}

///
/// SplitDefinition class is used to map split api data.
///
class SplitDefinition {
  SplitDefinition.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    environment = data['environment'];
    final treatmentsList = data['treatments'] as List<dynamic>;
    treatments =
        treatmentsList.map((element) => _Treatment.fromJson(element)).toList();
    defaultTreatment = data['defaultTreatment'];
    baselineTreatment = data['baselineTreatment'];
    trafficAllocation = data['trafficAllocation'];
  }

  late String id;
  late String name;
  late String defaultTreatment;
  late String baselineTreatment;
  late Map<String, dynamic> environment;
  late List<_Treatment> treatments;
  late int trafficAllocation;

  bool hasUserFeatures(String userName) {
    return _isInTreatmentOn(userName) || _isDefaultTreatmentOn();
  }

  bool _isDefaultTreatmentOn() => defaultTreatment == 'on';

  bool _isInTreatmentOn(String userName) {
    if (treatments.isNotEmpty) {
      final treatmentOn =
          treatments.firstWhere((element) => element.name == 'on');
      if (treatmentOn.keys.isNotEmpty) {
        try {
          final result = treatmentOn.keys
              .firstWhere((element) => userName == (element as String));
          return result != null;
        } catch (error) {
          return false;
        }
      }
    }
    return false;
  }
}

class _Treatment {
  _Treatment.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    description = data['description'];
    if (data.containsKey('keys')) {
      keys = data['keys'].map((element) => element as String).toList();
    }
  }

  late String name;
  late String description;
  late List<dynamic> keys = [];
}
