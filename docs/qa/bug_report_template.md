# Jira Bug Report Template & Logging Guide

If you find any issue while testing, you must log it in your Jira board. Below is the exact format to use.

## How to Log a Bug in Jira:
1. Open your Jira Project Dashboard.
2. Click **Create** (top navigation bar).
3. Set **Issue Type** to `Bug`.
4. Copy and paste the fields from the template below.
5. Attach the relevant screenshot from `docs/final_submission/evidence/app_screenshots/`.
6. Click **Create**.

---

## 🐞 Bug Template (Copy & Paste to Jira)

**Summary:** [Short descriptive title, e.g., UI overlapping on small screens in Cart]

**Description:**
*Preconditions:* 
User is logged in and has added 5 items to the cart.

*Steps to Reproduce:*
1. Navigate to the Cart Screen.
2. Scroll to the bottom to view the Checkout button.
3. Observe the Subtotal text.

*Expected Result:*
The Subtotal text should be fully visible above the Checkout button.

*Actual Result:*
The Subtotal text is partially hidden behind the sticky Checkout button on smaller devices.

**Environment:**
- Device: Emulator Pixel 6 / Physical Samsung S22
- OS: Android 13
- App Version: V1.0 Release

**Severity:** Medium
**Priority:** High
**Attachment:** `cart_ui_overlap_bug.png`
