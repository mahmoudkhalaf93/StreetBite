# Firebase App Distribution Guide

Follow these exact steps to upload your Release APK to Firebase and invite testers, fulfilling the Beta Distribution rubric requirement.

## Step 1: Locate your Release APK
If you successfully ran `flutter build apk --release`, your APK is located at:
`build/app/outputs/flutter-apk/app-release.apk`

*(Note: If the build failed locally due to the Windows Gradle cache bug, you can build it via a CI/CD pipeline like GitHub Actions or by resolving the local Gradle environment).*

## Step 2: Firebase Console Setup
1. Open your browser and go to the [Firebase Console](https://console.firebase.google.com/).
2. Select your `StreetBite` project.
3. In the left sidebar, under **Release & Monitor**, click **App Distribution**.
4. If this is your first time, click **Get Started**.
5. Select the **Android icon** (the StreetBite app) from the dropdown at the top.

## Step 3: Upload the APK
1. Drag and drop the `app-release.apk` file into the "Drag your APK here" box.
2. Wait for the upload to complete.

## Step 4: Add Testers
1. Once uploaded, click on the **Testers & Groups** tab.
2. Add at least two real email addresses (e.g., your second email, or a friend's email).
3. Go back to the **Releases** tab.
4. Select the release you just uploaded.
5. In the "Add testers or groups" box, type the emails you just added.
6. Add Release Notes: *"StreetBite V1.0 Release Candidate. Please test Home scrolling, Cart checkout, and Biometric login."*
7. Click **Distribute to X testers**.

## Step 5: Capture Evidence
Take a screenshot of the **Releases** tab showing the APK version, the Release Notes, and the number of invited testers.
Save this screenshot as `docs/final_submission/evidence/firebase_distribution/firebase_dashboard.png`.
