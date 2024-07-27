const String getTasksQuery = """
query GetTasks {
  tasks {
    id
    title
    description
    completed
  }
}
""";
