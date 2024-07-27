import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/task.dart';
import '../graphql/queries.dart';
import '../graphql/mutations.dart';

class TaskRepository {
  final GraphQLClient _client;

  TaskRepository(this._client);

  Future<List<Task>> getTasks() async {
    final result = await _client.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.noCache,
        document: gql(getTasksQuery),
      ),
    );

    if (result.hasException) {
      throw Exception('Failed to fetch tasks');
    }

    final List tasksJson = result.data!['tasks'];
    return tasksJson.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> createTask(String title, String description) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(createTaskMutation),
        variables: {
          'title': title,
          'description': description,
        },
      ),
    );

    if (result.hasException) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTask(
      String id, String title, String description, bool completed) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(updateTaskMutation),
        variables: {
          'id': id,
          'title': title,
          'description': description,
          'completed': completed,
        },
      ),
    );

    if (result.hasException) {
      throw Exception('Failed to update task');
    }
  }
}
