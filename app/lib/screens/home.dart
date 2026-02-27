import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final LatLng _initialPos = const LatLng(28.6139, 77.2090);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Stack(
        children: [

          // 🌍 OpenStreetMap
          FlutterMap(
            options: MapOptions(
              initialCenter: _initialPos,
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
            ],
          ),

          // 🔎 Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                height: 52,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        color: colors.onSurface.withOpacity(.6)),
                    const SizedBox(width: 10),
                    Text(
                      "Search location",
                      style: TextStyle(
                        color:
                            colors.onSurface.withOpacity(.6),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // 📦 Bottom Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    width: 40,
                    height: 4,
                    margin:
                        const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: colors.onSurface
                          .withOpacity(.25),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  Text(
                    "Need Roadside Help?",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Request a nearby mechanic instantly",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(
                      color:
                          colors.onSurface.withOpacity(.6),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Request Help",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}