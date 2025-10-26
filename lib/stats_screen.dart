import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'database_helper.dart';
import 'task_model.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalSessions = 0;
    if (_tasks.isNotEmpty) {
      totalSessions = _tasks
          .map((task) => task.pomodoroCount)
          .reduce((a, b) => a + b);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Progress Stats'), centerTitle: true),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryDarkText,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Total Completed Sessions',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.primaryDarkText.withOpacity(
                                    0.8,
                                  ),
                                  fontSize: 18,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            totalSessions.toString(),
                            style: GoogleFonts.fredoka(
                              color: AppColors.primaryDarkText,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: _tasks.isEmpty
                        ? Center(
                            child: Text(
                              'No tasks completed yet.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _tasks.length,
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.task_alt,
                                    color: AppColors.primaryDarkText,
                                  ),
                                  title: Text(
                                    task.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  trailing: Text(
                                    '${task.pomodoroCount} Sessions',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.primaryDarkText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
