import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:my_task/graphql_client.dart';
import 'package:my_task/task_model.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late GraphQLClient _client;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _client = initializeGraphQLClient();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final String mutation;
      final Map<String, dynamic> variables;

      if (widget.task == null) {
        mutation = r'''
        mutation($title: String!, $description: String!, $completed: Boolean!) {
          createTask(data: { title: $title, description: $description, completed: $completed }) {
            data {
              id
            }
          }
        }
      ''';

        variables = {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'completed': false,
        };
      } else {
        mutation = r'''
        mutation($id: ID!, $title: String!, $description: String!) {
          updateTask(id: $id, data: { title: $title, description: $description }) {
            data {
              id
            }
          }
        }
      ''';

        variables = {
          'id': widget.task!.id,
          'title': _titleController.text,
          'description': _descriptionController.text,
        };
      }

      final MutationOptions options = MutationOptions(
        document: gql(mutation),
        variables: variables,
      );

      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        print('Error: ${result.exception.toString()}');
      } else {
        Navigator.pop(
            context, true); // Pass 'true' indicating changes were made
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 163, 210, 180),
        title: Text(widget.task == null ? 'Add Task' : 'Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
