
package com.insaf.cilab;

import junit.framework.TestCase;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class TaskWebTest extends TestCase {

    private WebDriver driver;

    protected void setUp() {
        driver = new FirefoxDriver();
    }

    protected void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    public void testAddTask() {
        driver.get("http://localhost:8080/ci-app-1.0-SNAPSHOT/");

        driver.findElement(By.id("title"))
              .sendKeys("Test Selenium");

        driver.findElement(By.id("addTask"))
              .click();

        String task = driver.findElement(By.cssSelector("#taskList li"))
                          .getText();

        assertEquals("Test Selenium", task);
    }
}

