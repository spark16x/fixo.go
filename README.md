Got it. We’ll do two upgrades:

1️⃣ **Remove SOS button → make Home screen like Ola-style layout** (map-first + bottom action panel)
2️⃣ **Connect OTP with Firebase Phone Authentication** (real backend auth)

Clean, production direction. Let’s implement.

---

# ✅ Part 1 — Ola-Style Home Screen Layout

We’ll switch from big SOS button to a **map-first layout + bottom request panel**, similar to ride-service UX like Ola.

## Replace `screens/home_screen.dart`

This is UI-first (map placeholder now, real map next step).

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: Stack(
        children: [

          // Map placeholder (replace with GoogleMap later)
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'Map View (Coming Next)',
                style: TextStyle(color: Colors.white38),
              ),
            ),
          ),

          // Top search bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.white54),
                    SizedBox(width: 10),
                    Text(
                      "Search location",
                      style: TextStyle(color: Colors.white54),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Bottom action panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF111111),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const Text(
                    "Need Roadside Help?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Request a nearby mechanic instantly",
                    style: TextStyle(color: Colors.white60),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        // next: issue selection screen
                      },
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
```

---

# ✅ Part 2 — Firebase Phone OTP Authentication

Now we wire real OTP auth. This is backend-grade.

---

## 🔧 Step A — Add Packages

Run:

```bash
flutter pub add firebase_core
flutter pub add firebase_auth
```

---

## 🔧 Step B — Firebase Setup (Required)

In Firebase Console:

1. Create project → FIXO.GO
2. Add Android app → package name
3. Download `google-services.json` → put in:

```
android/app/google-services.json
```

4. Enable:

```
Firebase → Authentication → Phone → Enable
```

---

## 🔧 Step C — Android Config

### `android/build.gradle`

```gradle
classpath 'com.google.gms:google-services:4.4.0'
```

### `android/app/build.gradle`

```gradle
apply plugin: 'com.google.gms.google-services'
```

---

## 🔧 Step D — Init Firebase in `main.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
```

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

---

# ✅ Step E — Update Login Screen → Send OTP

## `login_screen.dart` (send OTP)

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_screen.dart';
```

Inside button:

```dart
onPressed: () async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: "+91$phone", // get from controller
    verificationCompleted: (credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
    },
    verificationFailed: (e) {
      debugPrint(e.message);
    },
    codeSent: (verificationId, _) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(verificationId: verificationId),
        ),
      );
    },
    codeAutoRetrievalTimeout: (_) {},
  );
}
```

---

# ✅ Step F — Update OTP Screen → Verify Code

## Change constructor:

```dart
class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});
```

---

## Verify button:

```dart
onPressed: () async {
  String code = _controllers.map((c) => c.text).join();

  final cred = PhoneAuthProvider.credential(
    verificationId: widget.verificationId,
    smsCode: code,
  );

  await FirebaseAuth.instance.signInWithCredential(cred);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  );
}
```

---

# ✅ You Now Have

✔ Ola-style map-first home UI
✔ SOS removed
✔ Bottom action panel UX
✔ Real Firebase OTP auth
✔ Production login flow

---

## Next high-impact move:

**Google Maps + live mechanic tracking** — this is where FIXO.GO becomes visually legit.

Say “maps next” and we wire it end-to-end.
