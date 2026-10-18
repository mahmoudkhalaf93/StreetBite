# Blockers

1. **Android Build Failure (Release)**
   - **Reason:** `flutter build apk --release` fails with an issue related to `AndroidLocationsBuildService`.
   - **Action needed:** Investigate and fix the Gradle configuration for Android build.

2. **Firebase App Distribution**
   - **Reason:** Requires authenticated access to Firebase and Firebase CLI, plus tester emails.
   - **Action needed from User:** 
     - Provide 2 tester email addresses.
     - Authenticate Firebase CLI or provide instructions to upload manually.

3. **Jira Bug Tracking**
   - **Reason:** Requires Jira account and project access.
   - **Action needed from User:**
     - Provide Jira project details or log the bugs manually using the provided templates.

4. **Appium Test Execution**
   - **Reason:** Requires a running emulator or physical device connected and authorized via ADB.
   - **Action needed from User:**
     - Start an emulator or connect a device and run the tests, OR provide emulator access if locally available.

5. **GitHub Publication**
   - **Reason:** Needs confirmation on target public repository.
   - **Action needed from User:**
     - Provide the public repository URL or follow instructions to push the existing repo.