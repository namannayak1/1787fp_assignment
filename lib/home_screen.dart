import 'package:flutter/material.dart';
import 'earnings_service.dart';
import 'transcript_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _tickerController = TextEditingController();
  List<EarningsData> earningsData = [];
  bool isLoading = false;

  void fetchEarningsData() async {
    setState(() => isLoading = true);
    final data = await EarningsService.fetchEarnings(_tickerController.text);
    setState(() {
      earningsData = data;
      isLoading = false;
    });
  }

  void onPointTap(EarningsData data) async {
    final transcript = await EarningsService.fetchTranscript(
      data.symbol, data.year, data.quarter,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TranscriptScreen(transcript: transcript),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Earnings Tracker"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Track Company Earnings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _tickerController,
              decoration: InputDecoration(
                labelText: "Enter Company Ticker",
                filled: true,
                fillColor: Colors.teal[50],
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: fetchEarningsData,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Get Earnings Data",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 25),
            if (isLoading)
              Center(child: CircularProgressIndicator(color: Colors.teal)),
            if (!isLoading && earningsData.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: earningsData
                              .map((e) => FlSpot(e.quarter.toDouble(), e.estimated))
                              .toList(),
                          isCurved: true,
                          color: Colors.teal[400]!,
                          barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.teal[100]!.withOpacity(0.3),
                          ),
                          dotData: FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: earningsData
                              .map((e) => FlSpot(e.quarter.toDouble(), e.actual))
                              .toList(),
                          isCurved: true,
                          color: Colors.orange[400]!,
                          barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.orange.withOpacity(0.3),
                          ),
                          dotData: FlDotData(show: true),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                          if (response != null && response.lineBarSpots != null) {
                            final index = response.lineBarSpots![0].spotIndex;
                            onPointTap(earningsData[index]);
                          }
                        },
                        handleBuiltInTouches: true,
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toString(),
                                style: TextStyle(
                                  color: Colors.teal[900],
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                "Q${value.toInt()}",
                                style: TextStyle(
                                  color: Colors.teal[900],
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.teal[200]!, width: 1),
                      ),
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(color: Colors.teal[100]!, strokeWidth: 0.8);
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(color: Colors.teal[100]!, strokeWidth: 0.8);
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
