package com.streetbite.tests;

import com.streetbite.base.BaseTest;
import io.appium.java_client.AppiumBy;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.PointerInput;
import org.openqa.selenium.interactions.Sequence;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.time.Duration;
import java.util.Collections;

public class HomeTest extends BaseTest {

    @Test(priority = 1)
    public void testScrollHomeAndAddToCart() throws InterruptedException {
        // Assume user is logged in and on Home Screen
        Thread.sleep(3000); // Wait for API to load meals

        // Perform a scroll down using W3C Actions
        PointerInput finger = new PointerInput(PointerInput.Kind.TOUCH, "finger");
        Sequence scroll = new Sequence(finger, 1);
        scroll.addAction(finger.createPointerMove(Duration.ZERO, PointerInput.Origin.viewport(), 500, 1500));
        scroll.addAction(finger.createPointerDown(PointerInput.MouseButton.LEFT.asArg()));
        scroll.addAction(finger.createPointerMove(Duration.ofMillis(1000), PointerInput.Origin.viewport(), 500, 300));
        scroll.addAction(finger.createPointerUp(PointerInput.MouseButton.LEFT.asArg()));
        driver.perform(Collections.singletonList(scroll));

        // Find "Add to Cart" button on a Recommended Meal and click
        WebElement addToCartBtn = driver.findElement(AppiumBy.xpath("//*[contains(@text, 'Add to Cart')]"));
        addToCartBtn.click();

        // Assert SnackBar appears
        WebElement snackbar = driver.findElement(AppiumBy.xpath("//*[contains(@text, 'added to cart')]"));
        Assert.assertTrue(snackbar.isDisplayed(), "Cart SnackBar did not appear");
    }
}
