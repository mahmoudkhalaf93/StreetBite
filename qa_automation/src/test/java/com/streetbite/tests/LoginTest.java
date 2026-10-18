package com.streetbite.tests;

import com.streetbite.base.BaseTest;
import io.appium.java_client.AppiumBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;
import org.testng.annotations.Test;

public class LoginTest extends BaseTest {

    @Test(priority = 1)
    public void testEmptyFields() {
        // Find Login Button and Click without entering data
        WebElement loginBtn = driver.findElement(AppiumBy.accessibilityId("Login")); // Replace with actual locator
        loginBtn.click();
        
        // Assert error messages
        WebElement emailError = driver.findElement(AppiumBy.xpath("//*[contains(@text, 'Email is required')]"));
        Assert.assertTrue(emailError.isDisplayed(), "Email required error not displayed");
    }

    @Test(priority = 2)
    public void testInvalidLogin() {
        // Enter invalid credentials
        driver.findElement(AppiumBy.xpath("//android.widget.EditText[1]")).sendKeys("wrong@email.com");
        driver.findElement(AppiumBy.xpath("//android.widget.EditText[2]")).sendKeys("wrongpass");
        
        driver.findElement(AppiumBy.accessibilityId("Login")).click();
        
        // Assert Firebase SnackBar error
        WebElement snackbar = driver.findElement(AppiumBy.xpath("//*[contains(@text, 'invalid')]"));
        Assert.assertTrue(snackbar.isDisplayed(), "Invalid login error not displayed");
    }

    @Test(priority = 3)
    public void testValidLogin() {
        // Clear previous inputs
        driver.findElement(AppiumBy.xpath("//android.widget.EditText[1]")).clear();
        driver.findElement(AppiumBy.xpath("//android.widget.EditText[2]")).clear();

        // Enter valid credentials
        driver.findElement(AppiumBy.xpath("//android.widget.EditText[1]")).sendKeys("test@test.com");
        driver.findElement(AppiumBy.xpath("//android.widget.EditText[2]")).sendKeys("123456");
        
        driver.findElement(AppiumBy.accessibilityId("Login")).click();
        
        // Assert Home Screen is reached (e.g. searching for the Home tab or Top bar)
        WebElement homeTitle = driver.findElement(AppiumBy.xpath("//*[contains(@text, 'Park Way 145') or contains(@text, 'Location')]"));
        Assert.assertTrue(homeTitle.isDisplayed(), "Failed to reach Home Screen");
    }
}
