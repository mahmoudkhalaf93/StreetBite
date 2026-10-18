# StreetBite V1.0 - Project Guidelines & Constraints

This document serves as the absolute source of truth for the StreetBite V1.0 Graduation Project. All development, architectural decisions, and feature implementations MUST strictly adhere to these rules. If there is a conflict between the UI design (Figma) and these requirements, **THESE REQUIREMENTS ALWAYS TAKE PRECEDENCE.**

## 1. Core Architecture & Technologies
- **Framework:** Flutter SDK and Dart.
- **Architecture:** Clean Architecture strictly separated into Data, Domain, and Presentation layers.
  - Every screen, BLoC/Cubit, UseCase, Repository, Model, Service, and Reusable Widget MUST be in its own Dart file.
- **State Management:** `flutter_bloc` / `Cubit`.
- **Dependency Injection:** `GetIt` (using Singleton, LazySingleton, and Factory).
- **Design Patterns Required:**
  - **Builder Pattern:** MUST be used for building the `UserModel`.
  - **Factory Pattern:** MUST be used in `MealRepository` to choose between remote (`Dio`) or local cached (`shared_preferences`) data sources.
  - **Singleton Pattern:** MUST be used for the Firestore service implementation.
  - **SOLID Principles:** MUST be applied, specifically mentioned for payment handling (separate cash and card classes implementing a common interface - *future feature*).

## 2. API & Data Handling
- **API Service:** TheMealDB API using `Dio` for requests, error handling, and caching.
- **Data Fetching:** Meals must be fetched from TheMealDB.
- **Caching:** Meal data MUST be cached using `shared_preferences` and restored on app restart.
- **Models:** Must provide `fromJson`/`toJson` factory constructors for API and Firestore models.
- **Error Handling:** Must catch network and Firebase errors and show friendly, localized messages; avoid unhandled exceptions.

## 3. Firebase & Backend Services
- **Authentication:** Firebase Authentication for email/password sign-in.
  - Must persist authentication state across app restarts.
  - Validation rules: Full name (capital first letter), email, password (minimum 6 characters), and password confirmation.
- **Database:** Cloud Firestore.
  - Used for storing user profiles, orders, and favourites (saved to the current user's Firestore document).
- **Beta Distribution:** Firebase App Distribution is required for the final release APK (with at least two testers).

## 4. UI/UX & Functional Requirements
- **General Layout:** Use `MediaQuery` to verify and ensure responsive UI on at least two screen sizes.
- **Theming:** Must support both Light and Dark themes.
  - *Crucial Rule:* Theme toggling MUST be controlled by a button connected to `ThemeBloc` in the UI (specifically in the Home Screen horizontal Hot Offers list/Header), NOT just relying on the device's system settings.
- **Localization:** Support English (EN) and Arabic (AR) using Flutter Localizations.
  - *Crucial Rule:* Localize **EVERY** visible string. **NO HARD-CODED UI TEXT.** Keep text in `.arb` files. Provide a runtime EN/AR language toggle.
- **Onboarding/Login:** Splash/onboarding screen requires a fade-in animation.
- **Home Screen:**
  - **Banner:** Use a `PageView` banner for featured (Fastest) meals.
  - **Hot Offers:** Add a horizontal Hot Offers list containing exactly five items. This section must also contain the theme toggle connected to ThemeBloc.
  - **Meal Grid:** Show a two-column `GridView` of meals (Recommended) with image, name, category, and an "Add-to-Cart" action.
- **Meal Details:** Open details from a meal card, passing the selected meal via navigation arguments. Display image, name, category, origin area, and instructions.
- **Cart & Orders:**
  - Dispatch "Add-to-Cart" to `CartBloc` and show a `SnackBar`.
  - Use `BlocBuilder` to render cart items and remove actions; update total reactively.
  - Use `BlocListener` to show a `SnackBar` when the cart becomes empty.
  - Save placed orders to Firestore and clear the cart.
- **Profile:** Display profile photo, name, email. Allow gallery photo selection with `image_picker`, upload to Firestore, update UI immediately. Load favourites and order history live from Firestore.

## 5. Bonus Features (To be implemented)
- **Vendor Map:** Full-screen Google Map titled “Nearby Vendors” using `google_maps_flutter`. At least 5 hardcoded vendor locations across different cities. Show vendor name, cuisine type, and rating in a marker info window.
- **Biometrics:** Require biometric fingerprint authentication (`local_auth`) before opening the profile screen.
- **Device Info:** Fetch device details using `device_info_plus`.

## 6. Code Quality & Formatting
- Clean code with clear structure.
- Clear naming conventions for all classes and variables.
- Avoid anti-patterns and over-engineered practices.
- Avoid duplicate code.
- Run `dart format .` before final submission.
- Remove unused code, imports, and ARB entries.
- Add comments explaining where and why each design pattern is used.

## 7. TheMealDB API Integration Details
We are using the free developer test key '1'.
- **Base URL:** `https://www.themealdb.com/api/json/v1/1/`
- **Endpoints to integrate:**
  - Search by name: `search.php?s={query}`
  - List by first letter: `search.php?f={letter}`
  - Lookup details by ID: `lookup.php?i={id}`
  - Random meal: `random.php`
  - List all categories: `categories.php`
  - Filter by Category: `filter.php?c={category}`
  - Filter by Area: `filter.php?a={area}`
  - Filter by Ingredient: `filter.php?i={ingredient}`

*Note: The project requires specific UI elements (like Theme Toggle in Hot Offers, PageView for banners, GridView for meals) even if the provided Figma design differs. Always follow these written instructions over the visual design if a conflict arises.*