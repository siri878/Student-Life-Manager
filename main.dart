import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskStore(),
      child: const StudentLifeApp(),
    ),
  );
}

// MODEL: represents one assignment/task.
class StudyTask {
  StudyTask({required this.title, required this.subject, this.isDone = false});
  final String title;
  final String subject;
  bool isDone;
}

// STATE MANAGEMENT: Provider notifies the UI whenever tasks change.
class TaskStore extends ChangeNotifier {
  final List<StudyTask> _tasks = [
    StudyTask(title: 'Revise Flutter widgets', subject: 'Mobile App Development'),
    StudyTask(title: 'Complete DSA problems', subject: 'Data Structures'),
    StudyTask(title: 'Prepare lab record', subject: 'Practical Lab', isDone: true),
  ];

  List<StudyTask> get tasks => List.unmodifiable(_tasks);
  int get completedCount => _tasks.where((task) => task.isDone).length;
  double get progress => _tasks.isEmpty ? 0 : completedCount / _tasks.length;

  void addTask(String title, String subject) {
    _tasks.insert(0, StudyTask(title: title, subject: subject));
    notifyListeners();
  }

  void toggleTask(StudyTask task) {
    task.isDone = !task.isDone;
    notifyListeners();
  }

  void removeTask(StudyTask task) {
    _tasks.remove(task);
    notifyListeners();
  }
}

class StudentLifeApp extends StatelessWidget {
  const StudentLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Life Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF477A68)),
        scaffoldBackgroundColor: const Color(0xFFF5F7F4),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7F4),
          foregroundColor: Color(0xFF20352D),
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/tasks': (_) => const TasksScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/add-task': (_) => const AddTaskScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TaskStore>();
    final width = MediaQuery.of(context).size.width;
    final wideLayout = width >= 650;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Life', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Hello, student 👋', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('Small steps today, big results tomorrow.', style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 22),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1EEE5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFD0E3D6)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('TODAY\'S PROGRESS', style: TextStyle(fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text('${store.completedCount} of ${store.tasks.length} tasks done', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(value: store.progress, minHeight: 9, backgroundColor: Colors.white, color: const Color(0xFF477A68)),
                          ),
                          const SizedBox(height: 8),
                          Text('${(store.progress * 100).round()}% completed'),
                        ]),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.auto_awesome, size: 48, color: Color(0xFF477A68)),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                if (wideLayout)
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: _QuickActionCard(icon: Icons.checklist_rounded, title: 'My tasks', subtitle: 'View and update assignments', onTap: () => Navigator.pushNamed(context, '/tasks'))),
                    const SizedBox(width: 14),
                    Expanded(child: _QuickActionCard(icon: Icons.add_task_rounded, title: 'Add a task', subtitle: 'Plan your next study session', onTap: () => Navigator.pushNamed(context, '/add-task'))),
                  ])
                else
                  Column(children: [
                    _QuickActionCard(icon: Icons.checklist_rounded, title: 'My tasks', subtitle: 'View and update assignments', onTap: () => Navigator.pushNamed(context, '/tasks')),
                    const SizedBox(height: 12),
                    _QuickActionCard(icon: Icons.add_task_rounded, title: 'Add a task', subtitle: 'Plan your next study session', onTap: () => Navigator.pushNamed(context, '/add-task')),
                  ]),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Next up', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/tasks'), child: const Text('See all')),
                ]),
                ...store.tasks.where((task) => !task.isDone).take(2).map((task) => TaskTile(task: task)),
                if (store.tasks.every((task) => task.isDone))
                  const Padding(padding: EdgeInsets.all(16), child: Text('Everything is complete. Great work! 🎉')),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigation(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskStore>().tasks;
    return Scaffold(
      appBar: AppBar(title: const Text('My tasks', style: TextStyle(fontWeight: FontWeight.w800))),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Add one to get started!'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => TaskTile(task: tasks[index], showDelete: true),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        icon: const Icon(Icons.add), label: const Text('New task'),
      ),
      bottomNavigationBar: const AppNavigation(currentIndex: 1),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _saveTask() {
    // FORM VALIDATION: only save when all validators pass.
    if (!_formKey.currentState!.validate()) return;
    context.read<TaskStore>().addTask(
      _titleController.text.trim(),
      _subjectController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task added successfully!')));
    Navigator.pushNamedAndRemoveUntil(context, '/tasks', (route) => route.settings.name == '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a task', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Icon(Icons.edit_note_rounded, size: 64, color: Color(0xFF477A68)),
                const SizedBox(height: 12),
                Text('Make a simple plan', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                const Text('Add what you want to finish next.', textAlign: TextAlign.center),
                const SizedBox(height: 26),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Task name', hintText: 'e.g. Revise chapter 2', prefixIcon: Icon(Icons.task_alt)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter a task name';
                    if (value.trim().length < 3) return 'Enter at least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subjectController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Subject', hintText: 'e.g. Flutter', prefixIcon: Icon(Icons.menu_book_outlined)),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a subject' : null,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(onPressed: _saveTask, icon: const Icon(Icons.save_outlined), label: const Padding(padding: EdgeInsets.all(12), child: Text('Save task'))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TaskStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('My profile', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const CircleAvatar(radius: 42, backgroundColor: Color(0xFFDDEBE1), child: Icon(Icons.school_rounded, size: 42, color: Color(0xFF477A68))),
            const SizedBox(height: 16),
            Text('Student', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const Text('Keep learning, one task at a time.'),
            const SizedBox(height: 24),
            Card(child: ListTile(leading: const Icon(Icons.check_circle_outline), title: const Text('Tasks completed'), trailing: Text('${store.completedCount}', style: const TextStyle(fontWeight: FontWeight.w800)))),
            Card(child: ListTile(leading: const Icon(Icons.assignment_outlined), title: const Text('Total tasks'), trailing: Text('${store.tasks.length}', style: const TextStyle(fontWeight: FontWeight.w800)))),
          ]),
        ),
      ),
      bottomNavigationBar: const AppNavigation(currentIndex: 2),
    );
  }
}

// REUSABLE CUSTOM WIDGET.
class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFE1EEE5), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: const Color(0xFF477A68))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), const SizedBox(height: 4), Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 12))])),
            const Icon(Icons.chevron_right),
          ]),
        ),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, this.showDelete = false});
  final StudyTask task;
  final bool showDelete;

  @override
  Widget build(BuildContext context) {
    final store = context.read<TaskStore>();
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: Checkbox(value: task.isDone, onChanged: (_) => store.toggleTask(task), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(fontWeight: FontWeight.w700, color: task.isDone ? Colors.grey : const Color(0xFF20352D), decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none),
          child: Text(task.title),
        ),
        subtitle: Text(task.subject),
        trailing: showDelete ? IconButton(tooltip: 'Delete task', icon: const Icon(Icons.delete_outline), onPressed: () => store.removeTask(task)) : Icon(task.isDone ? Icons.check_circle : Icons.circle_outlined, color: const Color(0xFF477A68), size: 20),
      ),
    );
  }
}

class AppNavigation extends StatelessWidget {
  const AppNavigation({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        const routes = ['/', '/tasks', '/profile'];
        if (index != currentIndex) Navigator.pushReplacementNamed(context, routes[index]);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.checklist_outlined), selectedIcon: Icon(Icons.checklist), label: 'Tasks'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
