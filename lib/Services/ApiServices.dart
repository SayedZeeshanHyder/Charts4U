import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

import '../apilink.dart';

class ApiService {

  Future<List<FlSpot>> fetchChartData() async {
    try {
      var response = await http.get(Uri.parse(apiUrl),headers: {
        'content-type': 'application/json',
      });

      final data = jsonDecode(response.body);
      final List<dynamic> chartData = data['records'];

      List<FlSpot> spots = chartData
          .where((entry) => entry['_year'] != 'Total') // Exclude "Total" entry
          .map((entry) => FlSpot(
        double.parse(entry['_year']), // x-axis value (year)
        double.parse(entry[
        'total_number_of_jobs_created__self_reported__by_dpiit_recognised_startups__as_on_30th_november_2022_'].toString()), // y-axis value (jobs created)
      ))
          .toList();

      return spots;
    } catch (e) {
      print("Error is $e");
      throw Exception('Failed to load data');
    }
  }
}
