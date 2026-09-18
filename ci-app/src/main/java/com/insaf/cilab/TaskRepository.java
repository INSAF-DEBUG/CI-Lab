package com.insaf.cilab;

import java.util.ArrayList;
import java.util.List;

public class TaskRepository {

    private final List<Task> tasks = new ArrayList<Task>();

    public void save(Task task) {
        tasks.add(task);
    }

    public List<Task> findAll() {
        return tasks;
    }
}
