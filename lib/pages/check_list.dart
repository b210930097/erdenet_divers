import 'dart:convert';
import 'package:erdenet_divers/pages/face_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CheckListScreen extends StatefulWidget {
  final String email;

  const CheckListScreen({super.key, required this.email}); // Update constructor

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final String response = await rootBundle.loadString('assets/answer.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _tasks = data.cast<Map<String, dynamic>>();
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Шалгах хуудас'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
                'Жолоочийн мэйл: ${widget.email}\nОн сар..............\nТээврийн хэрэгслийн нэр....'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final taskNumber = index + 1;

                return ListTile(
                  key: ValueKey(task['title']),
                  title: Text('$taskNumber. ${task['title']}'),
                  subtitle: task['isSelect']
                      ? DropdownButton<String>(
                          value: task['selectedOption'],
                          hint: const Text('Сонгох'),
                          items: task['options']
                              .map<DropdownMenuItem<String>>((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              task['selectedOption'] = newValue!;
                            });
                          },
                        )
                      : null,
                  leading: task['isSelect']
                      ? null
                      : Checkbox(
                          value: task['completed'],
                          onChanged: (value) => _toggleTaskCompletion(index),
                        ),
                  trailing: task['isSelect'] ? null : null,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const FaceDetectionScreen()),
          );
          setState(() {});
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
