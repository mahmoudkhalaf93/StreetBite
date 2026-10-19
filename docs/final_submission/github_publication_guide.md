# GitHub Repository Publication Guide

Follow these exact steps to ensure your project repository is ready and safe to share with your reviewers or the public.

## 1. Security Audit
✅ **Completed by AI:** I have removed `google-services.json` from git tracking and added it to `.gitignore`. Your Firebase project keys will not be exposed to the public! 

## 2. Pushing the Final Code
Your code has already been pushed to the `design` branch on your remote repository:
`https://github.com/mahmoudkhalaf93/StreetBite.git`

If you want to merge this to the `main` or `master` branch for final submission:
1. Open your terminal in the project directory.
2. Run the following commands:
   ```bash
   git checkout main   # (or git checkout master)
   git pull origin main
   git merge design
   git push origin main
   ```

## 3. Public Repository Settings
If your repository is currently private and you need to make it public for your graduation submission:
1. Go to your repository on GitHub.
2. Click on **Settings** (the gear icon).
3. Scroll down to the **Danger Zone** at the bottom of the General page.
4. Click **Change visibility**.
5. Select **Make public** and confirm.

## 4. Verification
- Open your GitHub repository URL in an Incognito/Private window.
- Ensure you can see the `README.md` file correctly formatted.
- Ensure the `android/app/google-services.json` file is **NOT** visible in the file explorer.
