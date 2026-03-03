# 🚗 FIXO.GO — FINAL STARTUP ARCHITECTURE

## 🎯 Business Model

* Marketplace for roadside assistance
* Manual quote selection
* Commission per job (15–20%)
* Delhi launch
* Two separate apps (User + Mechanic)

---

# 🏗 SYSTEM ARCHITECTURE (FINAL)

```text
User App (Flutter)
Mechanic App (Flutter)
        ↓
Firebase Backend
  • Auth
  • Firestore
  • Cloud Functions
  • FCM
        ↓
Geo Query Layer (GeoFlutterFire)
        ↓
Routing Engine (OpenRouteService)
        ↓
Map Layer (OpenStreetMap + flutter_map)
```

Fully serverless. Scales fast.

---

# 🗺 MAP & ROUTING STACK

## OpenStreetMap + OpenRouteService

![Image](https://wiki.openstreetmap.org/w/images/thumb/3/3a/SaintPierreDuPerray.jpg/300px-SaintPierreDuPerray.jpg)

![Image](https://ask.openrouteservice.org/uploads/default/original/2X/1/163320060de22d188af7181cdd32a7334e8da851.png)

![Image](https://repository-images.githubusercontent.com/517324391/c4fe7200-2c7d-449f-8bdb-663ce2b5185e)

![Image](https://miro.medium.com/1%2A4dSyF9z9lAYvHVxFPS_oiw.png)

### Why this stack?

* Free
* No billing surprises
* Route polyline
* ETA calculation
* Custom styling

---

# 📁 FINAL PROJECT STRUCTURE (Both Apps)

```text
lib/
│
├── core/
│   ├── config/
│   ├── constants/
│   ├── theme/
│   ├── errors/
│   ├── network/
│   ├── utils/
│   └── widgets/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories_impl/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── request/
│   ├── quotes/
│   ├── tracking/
│   ├── payment/
│   ├── history/
│   └── profile/
│
└── main.dart
```

State Management: **Riverpod**
Routing: **go_router**

---

# 🔥 FIRESTORE DATABASE DESIGN (FINAL)

## 1️⃣ users

```json
users/{userId}
{
  name,
  phone,
  role, // user or mechanic
  profileImage,
  rating,
  totalJobs,
  isOnline,
  vehicleDetails,
  location: GeoPoint,
  createdAt
}
```

---

## 2️⃣ service_requests

```json
service_requests/{requestId}
{
  userId,
  mechanicId: null,
  serviceType,
  pickupLocation: GeoPoint,
  status: "searching",
  broadcastRadius: 3000,
  agreedPrice: null,
  commissionAmount: null,
  createdAt,
  expiresAt
}
```

---

## 3️⃣ Quotes Subcollection

```json
service_requests/{requestId}/quotes/{mechanicId}
{
  mechanicId,
  proposedPrice,
  etaMinutes,
  distanceKm,
  createdAt
}
```

Mechanic can submit only one quote.

---

# 🚦 REQUEST STATE MACHINE (LOCKED DESIGN)

```text
CREATED
SEARCHING
QUOTES_RECEIVED
CONFIRMED
ON_THE_WAY
ARRIVED
IN_PROGRESS
COMPLETED
CANCELLED
EXPIRED
```

All transitions validated via Cloud Functions.

---

# ⚡ BROADCAST ENGINE (DELHI OPTIMIZED)

### Cloud Function: onRequestCreate

1. Geo-query mechanics within 3km
2. Filter isOnline == true
3. Send FCM individually
4. Start 60 sec timer
5. If no quotes → expand radius to 5km
6. Max radius 8km
7. If still no response → mark expired

No city-wide spam.

---

# 📱 USER APP COMPLETE FLOW

1. Splash
2. Auth (Phone OTP)
3. Home (Map + Service Selection)
4. Confirm Request
5. Searching Screen
6. Live Quotes Feed
7. Accept Quote
8. Live Tracking
9. Service Completion
10. Rating
11. History

---

# 🔧 MECHANIC APP COMPLETE FLOW

1. Auth + KYC
2. Availability Toggle
3. Incoming Request Alert
4. View Request
5. Submit Quote
6. Navigate
7. Update Status
8. Mark Complete
9. Earnings Dashboard

---

# 🔒 REQUEST LOCKING (CRITICAL)

When user taps Accept:

Cloud Function Transaction:

```text
if status == searching:
    set mechanicId
    set agreedPrice
    set status = confirmed
else:
    reject
```

All other quotes invalidated.

Prevents race condition chaos.

---

# 🚘 LIVE TRACKING SYSTEM

Mechanic location update interval:
Every 8–12 seconds

User listens via Firestore stream.

Route recalculation:
Every 30 seconds (not continuously).

Draw polyline using OpenRouteService.

---

# 💰 COMMISSION ENGINE

After completion:

```text
commission = agreedPrice × 0.15
```

Stored inside request.

Later integrate Razorpay split payments.

Start with:
Cash + UPI.

---

# 🛡 SECURITY RULES

Users:

* Can read only own requests
* Cannot change price

Mechanics:

* Can submit only one quote
* Cannot modify confirmed price
* Can update status only if assigned

Everything important verified server-side.

---

# 📊 PERFORMANCE OPTIMIZATION

* Use Firestore indexes
* Keep request documents lightweight
* Avoid frequent route recalculation
* Cache mechanic location locally
* Use connectivity_plus for offline handling

---

# 🚨 EDGE CASE HANDLING

You MUST implement:

• Mechanic cancels after confirm
• User cancels after confirm
• No quote scenario
• Internet loss during confirmation
• Mechanic fake quote detection
• Timeout auto-expiry

Add mechanic performance score.

---

# 📦 REQUIRED PACKAGES

```yaml
flutter_riverpod
go_router
firebase_core
firebase_auth
cloud_firestore
firebase_messaging
cloud_functions
geolocator
geoflutterfire2
flutter_map
dio
polyline_points
connectivity_plus
freezed
json_serializable
```

---

# 🚀 PHASED EXECUTION PLAN

## Phase 1 – Core Infrastructure (2–3 weeks)

* Auth
* Map
* Request creation
* Quote submission

## Phase 2 – Real-time Engine (2 weeks)

* Broadcast logic
* Live quotes
* Confirmation locking

## Phase 3 – Tracking & Completion (2 weeks)

* Route polyline
* Status transitions
* Commission logic

## Phase 4 – Trust Layer (1–2 weeks)

* Ratings
* Mechanic verification
* Earnings dashboard

---

# 📈 DELHI LAUNCH STRATEGY

Start with:

* 30–50 mechanics
* 3 focused zones (South, West, Central)
* Manual onboarding
* Offline marketing in workshops

Supply before demand.

---

# 🧠 STARTUP DIFFERENTIATORS

Add:

* Verified mechanic badge
* Fastest responder tag
* Emergency priority request
* Subscription model for mechanics later

---

# FINAL SYSTEM SUMMARY

You are building:

✔ Real-time quote marketplace
✔ Geo-dispatch engine
✔ Tracking system
✔ Commission revenue model
✔ Scalable Firebase backend
✔ Free map routing stack

This is production-ready for Delhi launch.

