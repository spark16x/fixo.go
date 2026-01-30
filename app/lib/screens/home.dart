import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedVehicle = 'Car';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'FIXO.GO',
          style: TextStyle(letterSpacing: 1.2),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            // Location Preview
            Column(
              children: const [
                Icon(Icons.location_on, color: Colors.blueAccent),
                SizedBox(height: 6),
                Text(
                  'Fetching your location...',
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),

            // SOS Button
            GestureDetector(
              onTap: () {
                // later: navigate to issue selection
                debugPrint('SOS Pressed');
              },
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Colors.redAccent, Colors.red],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),

            // Vehicle Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _vehicleButton('Car'),
                const SizedBox(width: 16),
                _vehicleButton('Bike'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleButton(String type) {
    final isSelected = selectedVehicle == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedVehicle = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          type,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
