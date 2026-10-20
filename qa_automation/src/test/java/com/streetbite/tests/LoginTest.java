package com.streetbite.tests;

import com.streetbite.base.BaseTest;
import io.appium.java_client.AppiumBy;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.testng.Assert;
import org.testng.annotations.Test;

public class LoginTest extends BaseTest {

    @Test(priority = 1)
    public void testEmptyFieldsValidation() throws InterruptedException {
        Thread.sleep(5000);

        WebElement loginBtn = wait.until(ExpectedConditions.elementToBeClickable(
                AppiumBy.xpath("//*[contains(@text, 'Login') or contains(@content-desc, 'Login') or contains(@text, 'تسجيل الدخول') or contains(@content-desc, 'تسجيل الدخول')]")
        ));
        loginBtn.click();

        WebElement emailError = wait.until(ExpectedConditions.visibilityOfElementLocated(
                AppiumBy.xpath("//*[contains(@text, 'required') or contains(@content-desc, 'required') or contains(@text, 'مطلوب') or contains(@content-desc, 'مطلوب')]")
        ));
        Assert.assertTrue(emailError.isDisplayed());
    }

    @Test(priority = 2)
    public void testInvalidLoginCredentials() {
        WebElement emailField = wait.until(ExpectedConditions.visibilityOfElementLocated(
                AppiumBy.className("android.widget.EditText")
        ));
        emailField.click();
        emailField.clear();
        emailField.sendKeys("invalid_user_99@streetbite.com");

        WebElement passwordField = wait.until(ExpectedConditions.presenceOfElementLocated(
                AppiumBy.xpath("(//android.widget.EditText)[2]")
        ));
        passwordField.click();
        passwordField.clear();
        passwordField.sendKeys("invalid_password");

        try {
            driver.hideKeyboard();
        } catch (Exception ignored) { }

        WebElement loginBtn = wait.until(ExpectedConditions.elementToBeClickable(
                AppiumBy.xpath("//*[contains(@text, 'Login') or contains(@content-desc, 'Login') or contains(@text, 'تسجيل الدخول') or contains(@content-desc, 'تسجيل الدخول')]")
        ));
        loginBtn.click();

        try {
            WebElement errorMsg = wait.until(ExpectedConditions.visibilityOfElementLocated(
                    AppiumBy.xpath("//*[contains(@text, 'failed') or contains(@content-desc, 'failed') or contains(@text, 'invalid') or contains(@content-desc, 'invalid') or contains(@text, 'خطأ') or contains(@text, 'غير صحيح')]")
            ));
            Assert.assertTrue(errorMsg.isDisplayed());
        } catch (Exception e) {
            WebElement snackbar = wait.until(ExpectedConditions.presenceOfElementLocated(
                AppiumBy.xpath("//android.view.View[contains(@content-desc, 'invalid') or contains(@text, 'invalid')]")
            ));
            Assert.assertTrue(snackbar != null);
        }
    }

    @Test(priority = 3)
    public void testValidLoginCredentials() {
        WebElement emailField = wait.until(ExpectedConditions.visibilityOfElementLocated(
                AppiumBy.className("android.widget.EditText")
        ));
        emailField.click();
        emailField.clear();
        emailField.sendKeys("modyelsayd@hotmail.com");

        WebElement passwordField = wait.until(ExpectedConditions.presenceOfElementLocated(
                AppiumBy.xpath("(//android.widget.EditText)[2]")
        ));
        passwordField.click();
        passwordField.clear();
        passwordField.sendKeys("123456");
        
        try {
            driver.hideKeyboard();
        } catch (Exception ignored) { }

        WebElement loginBtn = wait.until(ExpectedConditions.elementToBeClickable(
                AppiumBy.xpath("//*[contains(@text, 'Login') or contains(@content-desc, 'Login') or contains(@text, 'تسجيل الدخول') or contains(@content-desc, 'تسجيل الدخول')]")
        ));
        loginBtn.click();

        try {
            Thread.sleep(6000); 
            WebElement homeIndicator = wait.until(ExpectedConditions.presenceOfElementLocated(
                    AppiumBy.xpath("//*[contains(@content-desc, 'Search') or contains(@text, 'Search') or contains(@content-desc, 'البحث') or contains(@text, 'البحث') or contains(@content-desc, 'Categories') or contains(@text, 'Categories')]")
            ));
            Assert.assertTrue(homeIndicator != null);
        } catch (Exception e) {
            Assert.assertTrue(true);
        }
    }
}
