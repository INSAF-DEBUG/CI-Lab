package com.insaf.cilab.selenium.tests;

import com.insaf.cilab.selenium.pages.TaskPage;
import junit.framework.TestCase;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;

public class TaskFunctionalTest extends TestCase {

    private WebDriver driver;
    private TaskPage taskPage;

    protected void setUp() {
        driver = new FirefoxDriver();
        taskPage = new TaskPage(driver);
    }

    protected void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    public void testAddTask() {
        taskPage.open();

        taskPage.addTask("Test POM Selenium");

        String task = taskPage.getFirstTaskText();

        assertEquals("Test POM Selenium", task);
    }
}
