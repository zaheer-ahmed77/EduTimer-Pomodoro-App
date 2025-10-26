import 'dart:async';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'database_helper.dart';
import 'task_model.dart';
import 'notification_service.dart';
import 'settings_service.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'audio_service.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _remainingSeconds = 25 * 60;
  Timer? _timer;
  bool _isTimerRunning = false;
  String _currentMode = "FOCUS";

  final SettingsService _settingsService = SettingsService();
  int _focusDuration = 25;
  int _breakDuration = 5;

  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];
  bool _isLoading = true;

  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _refreshTasks();
    _loadSettingsAndApply();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _taskController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _loadSettingsAndApply() async {
    final settings = await _settingsService.loadSettings();
    setState(() {
      _focusDuration = settings['focus'] ?? 25;
      _breakDuration = settings['break'] ?? 5;
      if (!_isTimerRunning) {
        _remainingSeconds = _focusDuration * 60;
        _currentMode = "FOCUS";
      }
    });
  }

  void _openSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SettingsScreen()))
        .then((_) {
          _audioService.stopSound();
          _loadSettingsAndApply();
          _resetTimer();
        });
  }

  void _openStats() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const StatsScreen()));
  }

  Future<void> _refreshTasks() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  Future<void> _addTask() async {
    if (_taskController.text.isNotEmpty) {
      final newTask = Task(title: _taskController.text, pomodoroCount: 0);
      await DatabaseHelper.instance.insert(newTask);
      _taskController.clear();
      FocusScope.of(context).unfocus();
      _refreshTasks();
    }
  }

  Future<void> _deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    _refreshTasks();
  }

  Future<void> _completeSession(Task task) async {
    task.pomodoroCount++;
    await DatabaseHelper.instance.update(task);
    _refreshTasks();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = secs.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  void _startTimer() {
    if (_timer != null) _timer!.cancel();

    if (_currentMode == "FOCUS") {
      _audioService.playFocusSound();
    } else {
      _audioService.playBreakSound();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer!.cancel();
          _isTimerRunning = false;
          _changeMode();
        }
      });
    });
    setState(() => _isTimerRunning = true);
  }

  void _pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _audioService.stopSound();
      setState(() => _isTimerRunning = false);
    }
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _remainingSeconds = _focusDuration * 60;
      _currentMode = "FOCUS";
    });
  }

  void _changeMode() {
    _audioService.stopSound();

    if (_currentMode == "FOCUS") {
      NotificationService().showNotification(
        "Break Time!",
        "Good job! Time for a $_breakDuration minute break.",
      );
    } else {
      NotificationService().showNotification(
        "Focus Time!",
        "Time to get back to work for $_focusDuration minutes.",
      );
    }

    setState(() {
      _currentMode = (_currentMode == "FOCUS") ? "BREAK" : "FOCUS";
      _remainingSeconds = (_currentMode == "FOCUS")
          ? (_focusDuration * 60)
          : (_breakDuration * 60);
    });

    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduTimer'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: _openStats,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        _currentMode,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppColors.primaryDarkText,
                              letterSpacing: 4,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: GoogleFonts.fredoka(
                          color: AppColors.primaryDarkText,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_isTimerRunning)
                            ElevatedButton(
                              onPressed: _startTimer,
                              child: const Text('START'),
                            )
                          else
                            ElevatedButton(
                              onPressed: _pauseTimer,
                              child: const Text('PAUSE'),
                            ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: _resetTimer,
                            child: const Text('RESET'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 5.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _taskController,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Enter a new task...',
                            hintStyle: Theme.of(
                              context,
                            ).inputDecorationTheme.hintStyle,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, size: 30),
                        onPressed: _addTask,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryDarkText,
                      ),
                    )
                  : _tasks.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks added yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle_outline,
                              size: 28,
                            ),
                            title: Text(
                              task.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              'Completed: ${task.pomodoroCount}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.primaryLightText),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check_circle_outline),
                                  onPressed: () {
                                    _completeSession(task);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    _deleteTask(task.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
