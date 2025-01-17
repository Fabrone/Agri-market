import 'package:flutter/material.dart';
import 'package:agri_market/app_colors.dart';

class MarketAnalyticsPage extends StatefulWidget {
  const MarketAnalyticsPage({super.key});

  @override
  State<MarketAnalyticsPage> createState() => _MarketAnalyticsPageState();
}

class _MarketAnalyticsPageState extends State<MarketAnalyticsPage> {
  String _selectedTimeRange = 'Week';
  String _selectedMetric = 'Sales';

  final int totalSales = 50000;
  final int totalProductsSold = 150;
  final int totalUsers = 100; // Assuming total users for percentage calculation
  final int activeUsers = 75;

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
            _buildMetricsGrid(),
            _buildTrendingProducts(),
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

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: [
        _buildMetricCard('Total Sales', '₹$totalSales', Icons.trending_up),
        _buildMetricCard('Products Sold', '$totalProductsSold', Icons.shopping_cart),
        _buildMetricCard('Active Users', '$activeUsers', Icons.person),
        _buildMetricCard('Average Order', '₹${(totalSales / totalProductsSold).toStringAsFixed(2)}', Icons.assessment),
        _buildPercentageCard('Sales Percentage', (totalSales / 100000 * 100).toStringAsFixed(2)), // Assuming 100000 as a benchmark
        _buildPercentageCard('Active Users Percentage', (activeUsers / totalUsers * 100).toStringAsFixed(2)),
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

  Widget _buildPercentageCard(String title, String percentage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 14)),
            Text('$percentage%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: double.parse(percentage) / 100,
              backgroundColor: Colors.grey[300],
              color: AppColors.primaryGreen,
            ),
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
}
