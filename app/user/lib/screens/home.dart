import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final MapController _mapController = MapController();

  LatLng _currentPos = const LatLng(28.6139, 77.2090); // Delhi default
  bool loadingLocation = false;

  // ================= GET CURRENT LOCATION =================

  Future<void> _getCurrentLocation() async {

    setState(() => loadingLocation = true);

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => loadingLocation = false);
      return;
    }

    final position =
        await Geolocator.getCurrentPosition();

    final newPos =
        LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPos = newPos;
      loadingLocation = false;
    });

    _mapController.move(newPos, 15);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Stack(
        children: [

          /// 🌍 MAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPos,
              initialZoom: 14,
            ),
            children: [

              /// ✅ FIXED OSM TILE (NO ACCESS BLOCK)
              TileLayer(
                urlTemplate:
                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName:
                    "com.spark16x.fixogo", // change to your package name
              ),

              /// 📍 MARKER
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPos,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_pin,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// ================= TOP UI =================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// AVATAR + MENU ROW
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      /// 👤 USER AVATAR
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Open Profile")),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=3",
                          ),
                        ),
                      ),

                      /// ⋮ MENU
                      PopupMenuButton<String>(
                        icon:
                            const Icon(Icons.more_vert),
                        onSelected: (value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                                content: Text(value)),
                          );
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: "Settings",
                            child: Text("Settings"),
                          ),
                          PopupMenuItem(
                            value: "Help",
                            child: Text("Help"),
                          ),
                          PopupMenuItem(
                            value: "Logout",
                            child: Text("Logout"),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 🔎 SEARCH BAR
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    height: 52,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius:
                          BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color:
                              Colors.black.withOpacity(.15),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search,
                            color: colors.onSurface
                                .withOpacity(.6)),
                        const SizedBox(width: 10),
                        Text(
                          "Search location",
                          style: TextStyle(
                            color: colors.onSurface
                                .withOpacity(.6),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 📍 CURRENT LOCATION BUTTON
          Positioned(
            right: 16,
            bottom: 220,
            child: FloatingActionButton(
              mini: true,
              onPressed:
                  loadingLocation ? null : _getCurrentLocation,
              child: loadingLocation
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(Icons.my_location),
            ),
          ),

          /// ================= BOTTOM PANEL =================
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color:
                        Colors.black.withOpacity(.2),
                  )
                ],
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
                    style:
                        theme.textTheme.titleLarge
                            ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Request a nearby mechanic instantly",
                    style:
                        theme.textTheme.bodyMedium
                            ?.copyWith(
                      color: colors.onSurface
                          .withOpacity(.6),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Request Sent 🚀")),
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(
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