import 'package:flutter/material.dart';
import 'package:agri_market/screens/authentication/signup_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to the respective page based on the index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agrimarket Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _showMenu(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: const Text(
                'Welcome to Agrimarket!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Search Icon
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Navigate to search page
              },
              tooltip: 'Search',
            ),
            const SizedBox(height: 20),

            // Additional Features Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Features',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            _buildFeatureCard(context, 'Browse Products', Icons.shopping_cart, () {
              // Navigate to product browsing page
            }),
            _buildFeatureCard(context, 'Upload Products', Icons.upload_file, () {
              // Navigate to upload product page
            }),
            _buildFeatureCard(context, 'User Profile', Icons.person, () {
              // Navigate to user profile page
            }),
            _buildFeatureCard(context, 'Intuitive Agricultural Tools', Icons.build, () {
              // Navigate to agricultural tools page
            }),
            _buildFeatureCard(context, 'Weather Updates', Icons.wb_sunny, () {
              // Navigate to weather updates page
            }),
            _buildFeatureCard(context, 'Market Trends', Icons.trending_up, () {
              // Navigate to market trends page
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Marketplace',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Function onPressed) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () => onPressed(),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('User Profile'),
                onTap: () {
                  // Navigate to user profile
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Navigate to settings
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help'),
                onTap: () {
                  // Navigate to help
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const SignUpScreen(), // Navigate to Signup Screen
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Placeholder pages for navigation
class FarmerPage extends StatelessWidget {
  const FarmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Contributor')),
      body: const Center(child: Text('Farmer functionalities go here')),
    );
  }
}

class BuyerPage extends StatelessWidget {
  const BuyerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market Explorer')),
      body: const Center(child: Text('Product seeker functionalities go here')),
    );
  }
}
