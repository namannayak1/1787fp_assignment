import 'dart:convert';
import 'package:http/http.dart' as http;

class EarningsData {
  final String symbol;
  final int year;
  final int quarter;
  final double estimated;
  final double actual;

  EarningsData(this.symbol, this.year, this.quarter, this.estimated, this.actual);
}

class EarningsService {
  
  static const String apiKey = 'waLqlt/++23eJkTxGUcrZA==mVGCyuShDSmyozjs';

 
  static Future<List<EarningsData>> fetchEarnings(String symbol) async {
    try {
      final url = Uri.parse('https://api.api-ninjas.com/v1/earningscalendar?ticker=$symbol');
      final response = await http.get(url, headers: {'X-Api-Key': apiKey});

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => EarningsData(
          item['ticker'] ?? symbol,
          int.parse(item['pricedate']?.split('-')[0] ?? '0'), // Year
          (int.parse(item['pricedate']?.split('-')[1] ?? '1') + 2) ~/ 3, // Quarter
          (item['estimated_eps'] ?? 0.0).toDouble(),
          (item['actual_eps'] ?? 0.0).toDouble(),
        )).toList();
      } else {
        print('Failed to load data: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load earnings data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load earnings data');
    }
  }

  
 static Future<String> fetchTranscript(String symbol, int year, int quarter) async {
    try {
      final url = Uri.parse(
        'https://api.api-ninjas.com/v1/earningstranscript?ticker=$symbol&year=$year&quarter=$quarter'
      );
      final response = await http.get(url, headers: {'X-Api-Key': apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['transcript'] ?? 'Transcript not available';
      } else {
        print('Failed to load transcript: ${response.statusCode}, ${response.body}');
        return 'Transcript could not be retrieved';
      }
    } catch (e) {
      print('Error fetching transcript: $e');
      return 'Transcript could not be retrieved due to an error';
    }
  }
}