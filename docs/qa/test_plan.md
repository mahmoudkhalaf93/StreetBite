# StreetBite V1.0 - Master Test Plan

## 1. Objectives
The objective of this test plan is to ensure that StreetBite V1.0 meets all functional, non-functional, and UI/UX requirements specified in the Capstone assignment.

## 2. Scope
### In-Scope:
- Authentication (Login, Sign-up, Google Sign-in, Biometric).
- Navigation (Home, Browse, Orders, Profile).
- Core Features (Meal listing, Caching, Cart calculation, Checkout, Favourites).
- UI/UX (Responsive layout, Light/Dark theme, EN/AR Localization).
- Backend Integration (TheMealDB API, Firebase Auth, Firestore).

### Out-of-Scope:
- Facebook Sign-in (Marked as under construction).
- Payment gateway real transactions (mocked via Strategy Pattern).

## 3. Test Environment
- **Device:** Real Android Device (e.g., Samsung Galaxy S22) & Android Emulator.
- **OS Version:** Android 11+.
- **App Version:** V1.0 Release APK.
- **Network:** Wi-Fi / 4G (including offline mode testing for cache).

## 4. Test Types
- **Functional Testing:** Verifying core features work as intended.
- **UI/UX Testing:** Checking themes, responsiveness, and localization.
- **Integration Testing:** API responses and Firebase read/writes.
- **Usability Testing:** Smooth scrolling and correct state management.

## 5. Entry & Exit Criteria
- **Entry Criteria:** V1.0 source code is frozen, clean architecture is implemented, and release APK is generated.
- **Exit Criteria:** 100% of test cases executed, critical/high bugs resolved or documented, traceability matrix updated, and sign-off provided.
