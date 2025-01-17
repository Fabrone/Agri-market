import 'package:agri_market/screens/inventory_page.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
      child: charts.TimeSeriesChart(
        _createSampleTimeData(),
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
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
      child: charts.BarChart(
        _createSampleBarData(),
        animate: true,
        vertical: false,
      ),
    );
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleTimeData() {
    final data = [
      TimeSeriesSales(DateTime(2024, 1, 1), 5),
      TimeSeriesSales(DateTime(2024, 1, 2), 25),
      TimeSeriesSales(DateTime(2024, 1, 3), 100),
      TimeSeriesSales(DateTime(2024, 1, 4), 75),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  List<charts.Series<OrdinalSales, String>> _createSampleBarData() {
    final data = [
      OrdinalSales('Product 1', 5),
      OrdinalSales('Product 2', 25),
      OrdinalSales('Product 3', 100),
      OrdinalSales('Product 4', 75),
    ];

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}