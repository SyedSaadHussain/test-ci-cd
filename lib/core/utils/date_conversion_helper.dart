import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:mosque_management_system/data/services/network_service.dart';

class DateConversionHelper {
  final String baseUrl;

  DateConversionHelper({required this.baseUrl});

  // Helper method to convert a Gregorian date to Hijri
  Future<String> convertGregToHijri(String gregDate) async {
    String dateOld = gregDate.isEmpty ? "" : gregDate;
    final networkService = NetworkService(baseUrl: baseUrl);

    try {
      // Create the DateConversion instance
      DateConversion conversion = DateConversion(gregDate: gregDate);
      conversion.triggerValue();

      // Make the network request to convert the date
      final response = await networkService.get(
          "/api/gToH/" + (conversion.formatedGregDate ?? "")
      );

      // Parse the response to get Hijri values
      DateConversion dateConversion = DateConversion.fromJson(response);
      dateConversion.triggerValue();

      // Format and return the final string
      dateOld = (dateOld.isNotEmpty ? dateOld + ' / ' : '') +
          (dateConversion.yearHijri.toString() +
              '-' +
              (dateConversion.monthHijri ?? "") +
              '-' +
              (dateConversion.dayHijri ?? ""));
      return dateOld;
    } catch (e) {
      print('Error converting Greg to Hijri');
      print(e.toString());
      return dateOld;
    } finally {
      networkService.close();
    }
  }
}