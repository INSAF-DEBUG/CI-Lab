package com.insaf.cilab.selenium.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class TaskPage {

    private WebDriver driver;

    private By titleInput = By.id("title");
    private By addTaskButton = By.id("addTask");
    private By taskList = By.cssSelector("#taskList li");

    private String url = "http://localhost:8080/ci-app-1.0-SNAPSHOT/";

    public TaskPage(WebDriver driver) {
        this.driver = driver;
    }

    public void open() {
        driver.get(url);
    }

    public void addTask(String title) {
        driver.findElement(titleInput).sendKeys(title);
        driver.findElement(addTaskButton).click();
    }

    public String getFirstTaskText() {
        return driver.findElement(taskList).getText();
    }
}
