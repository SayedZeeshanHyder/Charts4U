import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Services/ApiServices.dart';

final chartDataProvider = FutureProvider((ref) async {
  return ApiService().fetchChartData();
});

final indexProvider = StateProvider<int>((ref) {
  return 0;
});

class ChartScreen extends ConsumerWidget {
  final List<String> availableGraphs = [
    "Line Chart",
    "Bar Chart",
    "Pie Chart",
    "Scatter Chart"
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartDataAsyncValue = ref.watch(chartDataProvider);
    final cardIndex = ref.watch(indexProvider);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart Screen'),
      ),
      body: chartDataAsyncValue.when(
        data: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: ListView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashFactory: NoSplash.splashFactory,
                          splashColor: Colors.transparent,
                          onTap: () {
                            ref.read(indexProvider.notifier).state = index;
                          },
                          child: Card(
                            color: cardIndex == index
                                ? Colors.green
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                availableGraphs[index],
                                style: TextStyle(
                                    color: cardIndex != index
                                        ? Colors.green
                                        : Colors.white),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                if (cardIndex == 0)
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: size.height * 0.8,
                    child: LineChart(
                      LineChartData(
                        backgroundColor: Colors.white,
                        // Chart background color
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 50000,
                          // Set grid line intervals for better readability
                          verticalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.5),
                              // Horizontal grid line color
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.5),
                              // Vertical grid line color
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            axisNameWidget: Text('Year',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            // X-axis label
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 2016:
                                    return Text('2016');
                                  case 2017:
                                    return Text('2017');
                                  case 2018:
                                    return Text('2018');
                                  case 2019:
                                    return Text('2019');
                                  case 2020:
                                    return Text('2020');
                                  case 2021:
                                    return Text('2021');
                                  case 2022:
                                    return Text('2022');
                                  default:
                                    return Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            axisNameWidget: Text('Jobs Created',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            // Y-axis label
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: (value, meta) {
                                if (value % 50000 == 0) {
                                  return Text(
                                      '${(value.toInt() / 1000).toInt()}k');
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: Colors.black.withOpacity(0.3),
                              width: 1), // Border color around the chart
                        ),
                        minX: 2016,
                        maxX: 2022,
                        minY: 0,
                        maxY: 250000,
                        // Set based on the data max value
                        lineBarsData: [
                          LineChartBarData(
                            spots: data as List<FlSpot>,
                            // Data points
                            isCurved: true,
                            // Make the line curved
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlueAccent],
                              // Line color gradient
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            barWidth: 4,
                            // Thickness of the line
                            isStrokeCapRound: true,
                            // Round edges of the line
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withOpacity(0.2),
                                  Colors.lightBlueAccent.withOpacity(0.1),
                                ], // Gradient under the line
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, bar, index) =>
                                  FlDotCirclePainter(
                                radius: 4,
                                color: Colors.blue, // Color of the dots
                                strokeWidth: 2,
                                strokeColor: Colors
                                    .white, // White border around the dots
                              ),
                            ),
                            // Add value labels directly on each data point
                            showingIndicators:
                                data.map((e) => data.indexOf(e)).toList(),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  '${spot.x.toInt()}: ${spot.y.toInt()} jobs',
                                  // Tooltip content
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                          touchCallback: (FlTouchEvent event,
                              LineTouchResponse? touchResponse) {
                            // Optional: Add interactivity
                          },
                          handleBuiltInTouches: true,
                        ),
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: 150000,
                              // An example threshold
                              color: Colors.redAccent,
                              strokeWidth: 2,
                              dashArray: [8, 4],
                              label: HorizontalLineLabel(
                                show: true,
                                alignment: Alignment.topRight,
                                labelResolver: (line) => 'Threshold',
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (cardIndex == 1)
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: size.height * 0.8,
                    child: BarChart(
                      BarChartData(
                        backgroundColor: Colors.white,
                        barGroups: [
                          BarChartGroupData(
                            x: 2016,
                            barRods: [
                              BarChartRodData(
                                toY: 150000,
                                width: 20,
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2017,
                            barRods: [
                              BarChartRodData(
                                toY: 160000,
                                width: 20,
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                          // Add other years similarly
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            axisNameWidget: Text('Year',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 2016:
                                    return Text('2016');
                                  case 2017:
                                    return Text('2017');
                                  case 2018:
                                    return Text('2018');
                                  case 2019:
                                    return Text('2019');
                                  case 2020:
                                    return Text('2020');
                                  case 2021:
                                    return Text('2021');
                                  case 2022:
                                    return Text('2022');
                                  default:
                                    return Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            axisNameWidget: Text('Jobs Created',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value % 50000 == 0) {
                                  return Text(
                                      '${(value.toInt() / 1000).toInt()}k');
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 50000,
                          verticalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.5),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: Colors.black.withOpacity(0.3), width: 1),
                        ),
                        maxY: 250000,
                      ),
                    ),
                  )
                else if (cardIndex == 2)
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: size.height * 0.8,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 150000,
                            color: Colors.blue,
                            title: '2016',
                            radius: 60,
                          ),
                          PieChartSectionData(
                            value: 160000,
                            color: Colors.lightBlue,
                            title: '2017',
                            radius: 60,
                          ),
                          // Add other sections for different years similarly
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius:
                            50, // Space in the center of the chart
                      ),
                    ),
                  )
                else if (cardIndex == 3)
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: size.height * 0.8,
                    child: ScatterChart(
                      ScatterChartData(
                        scatterSpots: [
                          ScatterSpot(2016, 150000,
                              show: true, ),
                          ScatterSpot(2017, 160000,
                            ),
                        ],
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 50000,
                          verticalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.5),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            axisNameWidget: Text('Year',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 2016:
                                    return Text('2016');
                                  case 2017:
                                    return Text('2017');
                                  case 2018:
                                    return Text('2018');
                                  case 2019:
                                    return Text('2019');
                                  case 2020:
                                    return Text('2020');
                                  case 2021:
                                    return Text('2021');
                                  case 2022:
                                    return Text('2022');
                                  default:
                                    return Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            axisNameWidget: Text('Jobs Created',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value % 50000 == 0) {
                                  return Text(
                                      '${(value.toInt() / 1000).toInt()}k');
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: Colors.black.withOpacity(0.3), width: 1),
                        ),
                        minX: 2016,
                        maxX: 2022,
                        minY: 0,
                        maxY: 250000,
                      ),
                    ),
                  )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading chart due to $error')),
      ),
    );
  }
}
