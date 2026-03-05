# Fixo.go Dual Apps Execution (User + Mechanic)

This repository now includes scaffolded parallel Flutter app codebases:

- `app/user_app` — user-facing app flow (auth, home, create request)
- `app/mechanic_app` — mechanic-facing flow (auth, availability toggle, incoming requests, quote submit)
- `app/shared_packages/fixogo_core` — shared constants/enums/models package skeleton

## Current status

### User app
- Email/password auth starter
- Basic go_router routes (`/`, `/home`, `/request`)
- Request creation writes to `service_requests`

### Mechanic app
- Email/password auth starter
- Availability toggle writes `users/{uid}.isOnline`
- Incoming searching requests stream
- Quote submit to `service_requests/{id}/quotes/{mechanicId}`

### Shared package
- Firestore path constants
- Request status enum
- User role enum
- ServiceRequest model

## Next implementation steps
1. Add Firebase options per app and platform folders (`android/ios/web`) using FlutterFire CLI.
2. Replace demo mechanic id with authenticated mechanic uid.
3. Implement Cloud Function-backed request locking and status transitions.
4. Add full screens listed in README (quotes feed, live tracking, completion, history, earnings).
5. Wire ORS routing + polyline refresh strategy.
