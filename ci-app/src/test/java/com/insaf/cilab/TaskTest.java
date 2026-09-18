package com.insaf.cilab;

import junit.framework.TestCase;

public class TaskTest extends TestCase {

    public void testTaskHasTitle() {
        Task task = new Task("Configurer Jenkins");

        assertEquals("Configurer Jenkins", task.getTitle());
    }

    public void testTaskWithEmptyTitle() {
        Task task = new Task("");

        assertEquals("", task.getTitle());
    }

    public void testSeveralTasksHaveDifferentTitles() {
        Task task1 = new Task("Configurer Jenkins");
        Task task2 = new Task("Configurer SonarQube");

        assertEquals("Configurer Jenkins", task1.getTitle());
        assertEquals("Configurer SonarQube", task2.getTitle());
    }
}
