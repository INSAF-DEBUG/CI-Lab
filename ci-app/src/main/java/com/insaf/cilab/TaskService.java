package com.insaf.cilab;

import java.util.List;

public class TaskService {

    private final TaskRepository repository;

    public TaskService(TaskRepository repository) {
        this.repository = repository;
    }

    public void createTask(String title) {
        Task task = new Task(title);
        repository.save(task);
    }

    public List<Task> getTasks() {
        return repository.findAll();
    }
}
