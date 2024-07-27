const String createTaskMutation = """
mutation CreateTask(\$title: String!, \$description: String) {
  addTask(title: \$title, description: \$description) {
    id
    title
    description
    completed
  }
}
""";

const String updateTaskMutation = """
mutation UpdateTask(\$id: ID!, \$title: String, \$description: String, \$completed: Boolean) {
  updateTask(id: \$id, title: \$title, description: \$description, completed: \$completed) {
    id
    title
    description
    completed
  }
}
""";
