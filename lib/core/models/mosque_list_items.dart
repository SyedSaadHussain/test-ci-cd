class MosqueListItem {
  final int id;
  final String name;          // e.g. "jmaid"
  final String? number;       // e.g. "MAK0124183111"
  final int? stageId;         // 190
   String? stageName;    // "Supervisor"
  final int? cityId;          // 2577
  final String? cityName;     // "محافظة جده"
  final DateTime? lastUpdate; // from "mosque_last_update"

  // UI helpers
  bool isLoading;
  bool hasOffline; // you can set this from Hive later if you want

  MosqueListItem({
    required this.id,
    required this.name,
    this.number,
    this.stageId,
    this.stageName,
    this.cityId,
    this.cityName,
    this.lastUpdate,
    this.isLoading = false,
    this.hasOffline = false,
  });

  factory MosqueListItem.fromJson(Map<String, dynamic> j) {
    int? _asInt(dynamic v) => v is int ? v : int.tryParse('$v');
    String? _asStr(dynamic v) => v?.toString();

    int? stId; String? stName;
    final st = j['stage_id'];
    if (st is List && st.isNotEmpty) {
      stId = _asInt(st[0]);
      if (st.length > 1) stName = _asStr(st[1]);
    }

    int? cId; String? cName;
    final city = j['city_id'];
    if (city is List && city.isNotEmpty) {
      cId = _asInt(city[0]);
      if (city.length > 1) cName = _asStr(city[1]);
    }

    DateTime? _parseDt(dynamic v) {
      if (v == null) return null;
      try { return DateTime.parse(v.toString()); } catch (_) { return null; }
    }

    return MosqueListItem(
      id: _asInt(j['id']) ?? 0,
      name: _asStr(j['name']) ?? '',
      number: _asStr(j['number']),
      stageId: stId,
      stageName: stName,
      cityId: cId,
      cityName: cName,
      lastUpdate: _parseDt(j['mosque_last_update']),
    );
  }

  MosqueListItem copyWith({bool? isLoading, bool? hasOffline}) => MosqueListItem(
    id: id,
    name: name,
    number: number,
    stageId: stageId,
    stageName: stageName,
    cityId: cityId,
    cityName: cityName,
    lastUpdate: lastUpdate,
    isLoading: isLoading ?? this.isLoading,
    hasOffline: hasOffline ?? this.hasOffline,
  );
}
