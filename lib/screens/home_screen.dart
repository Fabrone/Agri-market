import 'package:flutter/material.dart';
import 'package:agri_market/screens/authentication/signup_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agrimarket Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showMenu(context);
            },
          ),
        ],
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
            const SizedBox(height: 20),

            // User Type Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUserTypeButton(context, 'Crop Contributor', Icons.eco, () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FarmerPage(),
                  ));
                }),
                _buildUserTypeButton(context, 'Market Explorer', Icons.search, () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BuyerPage(),
                  ));
                }),
              ],
            ),
            const SizedBox(height: 40),

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
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeButton(BuildContext context, String title, IconData icon, Function onPressed) {
    return ElevatedButton.icon(
      onPressed: () => onPressed(),
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: Colors.green,
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
