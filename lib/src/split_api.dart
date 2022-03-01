import 'dart:convert';

import 'package:flutter_split/src/split.dart';

import 'http_client.dart';

class SplitAPI {
  static const String _baseHost = 'api.split.io';
  static const int _defaultOffset = 0;
  static const int _defaultLimit = 20;

  final _httpClient = HttpClient();

  ///
  /// Creates a new instance of SplitAPI.
  ///
  SplitAPI(
      {String? workspaceId,
      String? environmentIdOrName,
      String? apiKey,
      String? trafficType = 'user'}) {
    _workspaceId = workspaceId;
    _environment = environmentIdOrName;
    _apiKey = apiKey;
    _trafficTypeName = trafficType;
  }

  String? _workspaceId;
  String? _environment;
  String? _apiKey;
  String? _trafficTypeName;

  //////////////
  /// SPLITS ///
  //////////////

  ///
  /// Create a Split in your organization given a traffic type
  /// https://docs.split.io/reference/create-split
  ///
  Future<Split> createSplit({required String name, String? description}) async {
    final payload = {'name': name};
    if (description != null) {
      payload['description'] = description;
    }
    final response = await _httpClient.doPost(
        _buildUri(_buildSplitCreationUrl()),
        headers: _buildHeaders(),
        payload: payload);

    var jsonData = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception(jsonData);
    }

    return Split.fromJson(jsonData);
  }

  ///
  /// Get Split
  /// https://docs.split.io/reference/get-split
  ///
  Future<Split> getSplit({required String name}) async {
    final response = await _httpClient
        .doGet(_buildUri(_buildSplitNameUrl(name)), headers: _buildHeaders());

    var jsonData = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception(jsonData);
    }

    return Split.fromJson(jsonData);
  }

  ///
  /// Delete Split
  /// https://docs.split.io/reference/delete-split
  ///
  Future<void> deleteSplit({required String name}) async {
    final response = await _httpClient.doDelete(
        _buildUri(_buildSplitNameUrl(name)),
        headers: _buildHeaders());

    final jsonData = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception(jsonData);
    }
  }

  ///
  /// List Split names.
  /// https://docs.split.io/reference/list-splits
  ///
  Future<List<String>> listSplitsName(
      {int offset = _defaultOffset,
      int limit = _defaultLimit,
      String? tag}) async {
    final queryParams = _buildPaginationParams(offset, limit);
    if (tag != null) {
      queryParams['tag'] = tag;
    }
    final response = await _httpClient.doGet(
        _buildUri(_buildSplitsUrl(), queryParams),
        headers: _buildHeaders());
    var jsonData = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception(jsonData);
    }

    List<dynamic> list = jsonData['objects'];
    List<String> splitNames =
        list.map((element) => element['name'] as String).toList();
    return splitNames;
  }

  ///
  /// Retrieves Split Definition list.
  /// https://docs.split.io/reference/lists-split-definitions-in-environment
  ///
  Future<List<SplitDefinition>> getSplitDefinitionList(
      {int offset = _defaultOffset, int limit = _defaultLimit}) async {
    final urlPath = _buildSplitDefinitionListUrl();
    final response = await _httpClient.doGet(
        _buildUri(urlPath, _buildPaginationParams(offset, limit)),
        headers: _buildHeaders());
    var jsonData = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception(jsonData);
    }

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

    if (response.statusCode != 200) {
      throw Exception(jsonData);
    }

    return SplitDefinition.fromJson(jsonData);
  }

  String _buildSplitCreationUrl() =>
      '${_buildSplitsUrl()}/trafficTypes/$_trafficTypeName';

  String _buildSplitNameUrl(String name) => '${_buildSplitsUrl()}/$name';

  String _buildSplitDefinitionListUrl() =>
      '${_buildSplitsUrl()}/environments/$_environment';

  String _buildSplitDefinitionUrl(String name) =>
      '${_buildSplitsUrl()}/$name/environments/$_environment';

  String _buildSplitsUrl() => 'internal/api/v2/splits/ws/$_workspaceId';

  Map<String, dynamic> _buildPaginationParams(int offset, int limit) =>
      {'offset': offset.toString(), 'limit': limit.toString()};

  Uri _buildUri(
    String urlPath, [
    Map<String, dynamic>? queryParameters,
  ]) =>
      Uri.https(_baseHost, urlPath, queryParameters);

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

  @override
  String toString() => toJson().toString();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'defaultTreatment': defaultTreatment,
        'baselineTreatment': baselineTreatment,
        'environment': environment,
        'treatments': treatments,
        'trafficAllocation': trafficAllocation
      };

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

  Map<String, dynamic> toJson() =>
      {'name': name, 'description': description, 'keys': keys};
}
