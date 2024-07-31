import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:my_task/task_form_screen.dart';
import 'package:my_task/task_model.dart';
import 'package:my_task/graphql_client.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late GraphQLClient _client;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _client = initializeGraphQLClient();
    _fetchTasks(); // Fetch tasks initially
  }

  Future<void> _fetchTasks() async {
    const String query = r'''
    query {
      tasks {
        data {
          id
          attributes {
            title
            description
            completed
          }
        }
      }
    }
  ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        print('Error: ${result.exception.toString()}');
        if (result.exception!.graphqlErrors.isNotEmpty) {
          print('GraphQL Errors: ${result.exception!.graphqlErrors}');
        }
      } else {
        final List<Task> tasks = (result.data!['tasks']['data'] as List)
            .map((task) => Task.fromJson(task))
            .toList();

        setState(() {
          _tasks = tasks;
        });
      }
    } catch (e) {
      print('Fetch error: $e');
    }
  }

  Future<void> _deleteTask(String id) async {
    const String mutation = r'''
      mutation($id: ID!) {
        deleteTask(id: $id) {
          data {
            id
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'id': id,
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        print('Error: ${result.exception.toString()}');
      } else {
        setState(() {
          _tasks.removeWhere((task) => task.id == id);
        });
      }
    } catch (e) {
      print('Delete error: $e');
    }
  }

  Future<void> _updateTaskStatus(String id, bool completed) async {
    const String mutation = r'''
      mutation($id: ID!, $completed: Boolean!) {
        updateTask(id: $id, data: { completed: $completed }) {
          data {
            id
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'id': id,
        'completed': completed,
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        print('Error: ${result.exception.toString()}');
      } else {
        setState(() {
          final index = _tasks.indexWhere((task) => task.id == id);
          if (index != -1) {
            _tasks[index] = Task(
              id: _tasks[index].id,
              title: _tasks[index].title,
              description: _tasks[index].description,
              completed: completed,
            );
          }
        });
      }
    } catch (e) {
      print('Update error: $e');
    }
  }

  void _navigateToFormScreen({Task? task}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );

    if (result == true) {
      _fetchTasks(); // Refresh the list of tasks
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 203, 163, 210),
        title: Text('My Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh), // Reload icon
            onPressed: () {
              _fetchTasks(); // Reload the list
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _navigateToFormScreen();
            },
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: task.completed,
                        onChanged: (bool? value) {
                          if (value != null) {
                            _updateTaskStatus(task.id, value);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(task.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToFormScreen(task: task);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
