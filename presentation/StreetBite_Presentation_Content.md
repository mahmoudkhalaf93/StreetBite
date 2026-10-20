# StreetBite V1.0 - Graduation Presentation Content

*Instructions: Copy this content slide by slide into PowerPoint, Canva, or Google Slides. Add the screenshots mentioned.*

---

### Slide 1: Title Slide
- **Title:** StreetBite V1.0
- **Subtitle:** Flutter Food Discovery & Ordering App - Graduation Capstone
- **Visual:** StreetBite App Logo (`assets/icons/appicon.png` or `assets/images/applogofastfood.png`)
- **Footer:** Mahmoud Khalaf — Senior Flutter Engineer

---

### Slide 2: Problem Statement & Goals
- **Title:** Project Goals & Vision
- **Content:**
  - Build a responsive, bilingual (English/Arabic) food ordering application.
  - Implement Clean Architecture (Data, Domain, Presentation).
  - Integrate live APIs (TheMealDB) and Cloud Firestore for seamless data persistence.
  - Deliver a production-ready APK via Firebase App Distribution.
- **Visual:** Split-screen showing `home_light.jpg` and `home_dark.jpg` side-by-side.

---

### Slide 3: Development Workflow
- **Title:** Agile & DevOps Workflow
- **Content:**
  - **Version Control:** GitHub for branching and commits.
  - **QA & Automation:** Jira for bug tracking, Appium + Java for UI automation.
  - **Beta Delivery:** Firebase App Distribution for tester feedback.
- **Visual:** Flowchart arrows: `Code (Flutter)` ➔ `Test (Appium/QA)` ➔ `Deploy (Firebase)` + Screenshot: `test_app.jpg`.

---

### Slide 4: Technologies & Architecture
- **Title:** Tech Stack & Clean Architecture
- **Content:**
  - **Framework:** Flutter & Dart
  - **State Management:** flutter_bloc (Cubit)
  - **DI:** GetIt (Service Locator)
  - **Networking & Cache:** Dio + SharedPreferences (Stale-While-Revalidate pattern)
  - **Backend:** Firebase Auth, Firestore, Storage
- **Visual:** A standard 3-layer Clean Architecture diagram (Presentation ➔ Domain ➔ Data).

---

### Slide 5: Features - Home & API
- **Title:** Dynamic Home Screen & Live API
- **Content:**
  - Fetches 14 real food categories and live meals from TheMealDB.
  - Implements True Lazy Loading using `CustomScrollView` and `Slivers`.
  - Zero-lag image caching with `CachedNetworkImage` and `memCacheWidth`.
- **Visual:** Screenshots: `home_light_arabic.jpg` and `categories_light_a.jpg`.

---

### Slide 6: Features - Cart & Firebase
- **Title:** Live Cart & Orders Persistence
- **Content:**
  - Calculates subtotal, delivery fees, taxes, and final total dynamically.
  - Geolocator address picker with 150m proximity duplicate prevention.
  - Synchronizes active Cart and Orders live with Cloud Firestore.
  - 30-minute Live Countdown Timer for active deliveries.
- **Visual:** Screenshots: `cart_pickup_light.jpg` and `orders_arabic_light.jpg`.

---

### Slide 7: Security & Biometrics (Bonus)
- **Title:** High Security & Biometric Login
- **Content:**
  - Fingerprint / FaceID integration via `local_auth`.
  - Securely binds biometrics to the specific user's UID in SharedPreferences.
  - Protects sensitive Profile actions behind biometric guards.
- **Visual:** Screenshots: `profile_enabled_biometric_to_login_dark.jpg` and `login_with_fingerprint.jpg`.

---

### Slide 8: Vendor Map (Bonus)
- **Title:** Nearby Vendors Map
- **Content:**
  - Integrated `google_maps_flutter`.
  - Displays 5 nearby local vendor pins.
  - Custom InfoWindows showing Vendor Name, Cuisine, and Rating.
- **Visual:** Screenshots: `nearby_vendors.jpg` and `nearby_vendors_pop_up_dialog_dark.jpg`.

---

### Slide 9: Testing Strategy
- **Title:** QA & Appium Automation
- **Content:**
  - Detailed Manual Test Plan and Traceability Matrix in `docs/qa/`.
  - 100% Passing Rate on Critical UI flows.
  - **Appium Java Automation:** Scripts written for Login validation and Home scrolling (W3C Actions).
- **Visual:** Screenshot of IDE running Appium Java tests or TestNG console output.

---

### Slide 10: Conclusion & Future Scope
- **Title:** Lessons Learned & Future Scope
- **Content:**
  - Successfully bridged Clean Architecture with complex Flutter State Management.
  - **Future:** Integrate real payment gateways (Stripe/Paymob) and push notifications.
- **Footer:** Thank You! Q&A.
