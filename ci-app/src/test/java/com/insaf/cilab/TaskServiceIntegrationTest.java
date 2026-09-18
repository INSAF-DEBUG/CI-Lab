package com.insaf.cilab;

import junit.framework.TestCase;

public class TaskServiceIntegrationTest extends TestCase {

    public void testCreateTaskAndRetrieveIt() {
        TaskRepository repository = new TaskRepository();
        TaskService service = new TaskService(repository);

        service.createTask("Configurer Jenkins");

        assertEquals(1, service.getTasks().size());
        assertEquals("Configurer Jenkins",
                     service.getTasks().get(0).getTitle());
    }

    public void testCreateSeveralTasks() {
        TaskRepository repository = new TaskRepository();
        TaskService service = new TaskService(repository);

        service.createTask("Configurer Jenkins");
        service.createTask("Configurer SonarQube");

        assertEquals(2, service.getTasks().size());
        assertEquals("Configurer Jenkins",
                     service.getTasks().get(0).getTitle());
        assertEquals("Configurer SonarQube",
                     service.getTasks().get(1).getTitle());
    }
}
