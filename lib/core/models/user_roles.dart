import 'userProfile.dart';

enum UserRole {
  MMC07,
  MMC05,
  MMC06,
  MMC02
}

enum UserRoleLevel {
  levelA, // supervisor (all regions)
  levelB, // one region
  levelC, // one city
}

extension UserRoleChecks on UserProfile {
  Set<String> get roleCodes => (roleNames ?? const [])
      .map((r) => r.trim().toUpperCase())
      .toSet();

  bool hasLevelA() {
    const accessAllRegions = {'MAA01', 'MMA01', 'IUA04'};
    return roleCodes.any(accessAllRegions.contains);
  }

  bool hasLevelB() {
    const accessOneRegion = {'IUB01', 'IUB04', 'BMB01', 'MMB01', 'MMB02', 'MMB03'};
    return roleCodes.any(accessOneRegion.contains);
  }

  bool hasLevelC() {
    const accessOneCity = {'MMC02', 'MMC03'};
    return roleCodes.any(accessOneCity.contains);
  }
}