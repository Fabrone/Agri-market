import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:agri_market/app_colors.dart';

class MarketAnalyticsPage extends StatefulWidget {
  const MarketAnalyticsPage({super.key});

  @override
  State<MarketAnalyticsPage> createState() => _MarketAnalyticsPageState();
}

class _MarketAnalyticsPageState extends State<MarketAnalyticsPage> {
  String _selectedTimeRange = 'Week';
  String _selectedMetric = 'Sales';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Analytics'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFilterSection(),
            _buildMainChart(),
            _buildMetricsGrid(),
            _buildTrendingProducts(),
            _buildPriceAnalysis(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: _selectedTimeRange,
              isExpanded: true,
              items: ['Day', 'Week', 'Month', 'Year']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTimeRange = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedMetric,
              isExpanded: true,
              items: ['Sales', 'Revenue', 'Products', 'Users']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMetric = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          lineBarsData: _createSampleLineData(),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }

  List<LineChartBarData> _createSampleLineData() {
    return [
      LineChartBarData(
        spots: [
          const FlSpot(1, 5),
          const FlSpot(2, 25),
          const FlSpot(3, 100),
          const FlSpot(4, 75),
        ],
        isCurved: true,
        color: AppColors.primaryGreen, // Changed from colors to color
        barWidth: 4,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(show: false),
      ),
    ];
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: [
        _buildMetricCard('Total Sales', '₹50,000', Icons.trending_up),
        _buildMetricCard('Products Sold', '150', Icons.shopping_cart),
        _buildMetricCard('Active Users', '75', Icons.person),
        _buildMetricCard('Average Order', '₹333', Icons.assessment),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: AppColors.primaryGreen),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14)),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingProducts() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.secondaryGreen,
                  child: Text('${index + 1}'),
                ),
                title: Text('Product ${index + 1}'),
                subtitle: Text('${100 - index * 10} units sold'),
                trailing: Text('₹${1000 - index * 100}'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAnalysis() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          barGroups: _createSampleBarData(),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          barTouchData: BarTouchData(enabled: false),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createSampleBarData() {
    return [
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 5, color: AppColors.primaryGreen)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 25, color: AppColors.primaryGreen)]),
      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 100, color: AppColors.primaryGreen)]),
      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 75, color: AppColors.primaryGreen)]),
    ];
  }
}
