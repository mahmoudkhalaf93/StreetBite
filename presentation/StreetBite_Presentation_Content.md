# StreetBite V1.0 - Graduation Presentation Content

*Instructions: Copy this content slide by slide into PowerPoint, Canva, or Google Slides. Add the screenshots mentioned.*

---

### Slide 1: Title Slide
- **Title:** StreetBite V1.0
- **Subtitle:** Flutter Food Discovery & Ordering App - Graduation Capstone
- **Visual:** StreetBite App Logo (Use `assets/icons/appicon.png` or `assets/images/applogofastfood.png`)
- **Footer:** Your Name / Team Name

---

### Slide 2: Problem Statement & Goals
- **Title:** Project Goals & Vision
- **Content:**
  - Build a responsive, bilingual (English/Arabic) food ordering application.
  - Implement Clean Architecture (Data, Domain, Presentation).
  - Integrate live APIs (TheMealDB) and Cloud Firestore for seamless data persistence.
  - Deliver a production-ready APK via Firebase App Distribution.
- **Visual:** Split-screen showing the Light Mode and Dark Mode of the Home Screen side-by-side.

---

### Slide 3: Development Workflow
- **Title:** Agile & DevOps Workflow
- **Content:**
  - **Version Control:** GitHub for branching and commits.
  - **QA & Automation:** Jira for bug tracking, Appium + Java for UI automation.
  - **Beta Delivery:** Firebase App Distribution for tester feedback.
- **Visual:** Flowchart arrows: `Code (Flutter)` ➔ `Test (Appium/QA)` ➔ `Deploy (Firebase)`.

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
- **Visual:** Screenshot: `home_screen_en.png`.

---

### Slide 6: Features - Cart & Firebase
- **Title:** Live Cart & Orders Persistence
- **Content:**
  - Calculates subtotal, delivery fees, taxes, and final total dynamically.
  - Prevents checkout without a Geo-located Address.
  - Synchronizes active Cart and Orders live with Cloud Firestore.
  - 30-minute Live Countdown Timer for active deliveries.
- **Visual:** Screenshot: `cart_screen.png` and `orders_screen.png`.

---

### Slide 7: Security & Biometrics (Bonus)
- **Title:** High Security & Biometric Login
- **Content:**
  - Fingerprint / FaceID integration via `local_auth`.
  - Securely binds biometrics to the specific user's UID and email in SharedPreferences.
  - Protects sensitive Profile actions (Payment Info, Addresses) behind biometric guards.
- **Visual:** Screenshot: `biometric_prompt.png`.

---

### Slide 8: Vendor Map (Bonus)
- **Title:** Nearby Vendors Map
- **Content:**
  - Integrated `google_maps_flutter`.
  - Displays 5 hardcoded local vendor pins.
  - Custom InfoWindows showing Vendor Name, Cuisine, and Rating.
- **Visual:** Screenshot: `vendor_map.png`.

---

### Slide 9: Testing Strategy
- **Title:** QA & Appium Automation
- **Content:**
  - Detailed Manual Test Plan and Traceability Matrix.
  - 100% Passing Rate on Critical UI flows.
  - **Appium Java Automation:** Scripts written for Login validation, Home scrolling (W3C Actions), and Cart SnackBar assertions.
- **Visual:** Screenshot of the IDE running Appium Java tests or TestNG console output.

---

### Slide 10: Conclusion & Future Scope
- **Title:** Lessons Learned & Future Scope
- **Content:**
  - Successfully bridged Clean Architecture with complex Flutter State Management.
  - **Future:** Integrate real payment gateways (Stripe/Paymob) and push notifications.
- **Footer:** Thank You! Q&A.
