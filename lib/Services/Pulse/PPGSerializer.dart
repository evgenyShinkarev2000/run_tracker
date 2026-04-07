import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Services/Pulse/BrightnessWithDuration.dart';

class PPGSerializer {
  static const String microsecondsHeader = "microseconds";
  static const String brightnessHeader = "brightness";
  static const String delimiter = ",";
  static const String _exportHeader =
      "$microsecondsHeader$delimiter$brightnessHeader";

  Future<String> exportCSVString(List<BrightnessWithDuration> meausurements) {
    final stringBuffer = StringBuffer(_exportHeader);
    for (final measurement in meausurements) {
      stringBuffer.writeln();
      stringBuffer.write(measurement.duration.inMicroseconds);
      stringBuffer.write(delimiter);
      stringBuffer.write(measurement.brightness.toString());
    }

    return Future.value(stringBuffer.toString());
  }

  Future<List<BrightnessWithDuration>> importCSVString(String csvString) {
    assert(csvString.isNotEmpty);
    final lines = csvString.split("\n");
    final result = <BrightnessWithDuration>[];
    final parser = _getLineParser(lines.first);
    for (final indexWithline in lines.skip(1).indexed) {
      try {
        result.add(parser(indexWithline.$2));
      } catch (ex, s) {
        throw AppException(
          message:
              "Exception when parse line ${indexWithline.$2} with index ${indexWithline.$1 + 1}. See inner exception.",
          stackTrace: s,
          innerException: AppException.inner(ex),
        );
      }
    }

    return Future.value(result);
  }

  BrightnessWithDuration Function(String) _getLineParser(
    String csvHeadersLine,
  ) {
    final columnHeaders = csvHeadersLine.split(delimiter);
    int microsecondsIndex = -1;
    int brightnessIndex = -1;

    for (final indexWithHeader in columnHeaders.indexed) {
      final clearHeader = indexWithHeader.$2.trim();
      if (clearHeader == microsecondsHeader) {
        microsecondsIndex = indexWithHeader.$1;
      }
      if (clearHeader == brightnessHeader) {
        brightnessIndex = indexWithHeader.$1;
      }
      if (microsecondsIndex != -1 && brightnessIndex != -1) {
        break;
      }
    }

    if (microsecondsIndex == -1) {
      _throwMissedHeaderException(csvHeadersLine, microsecondsHeader);
    }
    if (brightnessIndex == -1) {
      _throwMissedHeaderException(csvHeadersLine, brightnessHeader);
    }

    return (String line) {
      final tokens = line.split(delimiter);
      if (tokens.length <= microsecondsIndex) {
        _throwIndexOutOfRangeException(
          csvHeadersLine,
          line,
          microsecondsIndex,
          microsecondsHeader,
        );
      }
      if (tokens.length <= brightnessIndex) {
        _throwIndexOutOfRangeException(
          csvHeadersLine,
          line,
          brightnessIndex,
          brightnessHeader,
        );
      }
      final microseconds = int.tryParse(tokens[microsecondsIndex]);
      if (microseconds == null) {
        _throwCantParseException(
          tokens[microsecondsIndex],
          microsecondsHeader,
          line,
          "int",
        );
      }
      final brightness = double.tryParse(tokens[brightnessIndex]);
      if (brightness == null) {
        _throwCantParseException(
          tokens[brightnessIndex],
          brightnessHeader,
          line,
          "double",
        );
      }
      if (!brightness!.isFinite) {
        throw AppException(
          message: "brightness must be finite real number, got $brightness",
        );
      }

      return BrightnessWithDuration(
        brightness: brightness,
        duration: Duration(microseconds: microseconds!),
      );
    };
  }

  static void _throwMissedHeaderException(String line, String missedHeader) {
    throw AppException(
      message:
          "PPGSerializer can't find header $missedHeader in headers $line splitted by delimiter $delimiter during import",
    );
  }

  static void _throwIndexOutOfRangeException(
    String csvHeader,
    String csvLine,
    int headerIndex,
    String header,
  ) {
    throw AppException(
      message:
          "PPGSerializer can't parse line $csvLine, becouse index of header $header = $headerIndex from headers $csvHeader not contained in line splitted by delimiter $delimiter",
    );
  }

  static void _throwCantParseException(
    String token,
    String header,
    String line,
    String type,
  ) {
    throw AppException(
      message:
          "Can't parse token $token for header $header from line $line to type $type",
    );
  }
}
