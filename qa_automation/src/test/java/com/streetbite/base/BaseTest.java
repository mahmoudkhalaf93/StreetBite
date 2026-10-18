package com.streetbite.base;

import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.options.UiAutomator2Options;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;

import java.net.MalformedURLException;
import java.net.URL;
import java.time.Duration;

public class BaseTest {
    protected AndroidDriver driver;

    @BeforeClass
    public void setup() throws MalformedURLException {
        UiAutomator2Options options = new UiAutomator2Options();
        options.setPlatformName("Android");
        // Update this path to where your actual APK is located after running 'flutter build apk'
        options.setApp(System.getProperty("user.dir") + "/../build/app/outputs/flutter-apk/app-release.apk");
        options.setAutomationName("UiAutomator2");
        options.setAppPackage("com.example.streetbite");
        options.setAppActivity(".MainActivity");
        options.setAutoGrantPermissions(true);

        driver = new AndroidDriver(new URL("http://127.0.0.1:4723"), options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
    }

    @AfterClass
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
