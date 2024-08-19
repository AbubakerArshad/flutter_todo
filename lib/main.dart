import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/notes_provider.dart';
import 'package:todo_app/provider/simple_provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/view/create_note_screen.dart';
import 'package:todo_app/view/create_task_screen.dart';

import 'db/database_helper.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SimpleProvider()),
          ChangeNotifierProvider(create: (_) => TaskProvider()),
          ChangeNotifierProvider(create: (_) => NotesProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: ''),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> add(Task task) async {
    Map<String, dynamic> row = {
      "title": task.title,
      "isDone": task.isDone,
      "dateTime": task.dateTime
    };
    final id = await dbHelper.createTask(row);
    debugPrint('inserted row id: $id');
  }

  final List<String> tabTitles = ['Tasks', 'Notes'];

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final notesProvider = Provider.of<NotesProvider>(context);

    taskProvider.loadTasks();
    notesProvider.loadNotes();

    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo App' ,style: TextStyle(fontSize: 30 ,color: Colors.indigo, fontWeight: FontWeight.bold),),
          bottom: TabBar(
            tabs: tabTitles.map((title) => Tab(text: title)).toList(),
          ),
        ),
        body: TabBarView(children: [
          Scaffold(
            body: Container(
                color: Colors.black54,
                child: ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        InkWell(
                          child: Container(
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    // Text(taskProvider.tasks[index].title! ,style: const TextStyle(color: Colors.blue),),
                                    // Text(taskProvider.tasks[index].isDone == 1 ? "Done" : "Pending" ,style: const TextStyle(color: Colors.red),),
                                    //     ElevatedButton(
                                    //       onPressed: () {
                                    //         // provider.name = "Text Changed By Provider  !!!";
                                    //         taskProvider.markAsDoneTask(taskProvider.tasks[index]);
                                    //       },
                                    //       child: const Text('Mark as Done'),
                                    //     )
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Checkbox(value: taskProvider.tasks[index].isDone ==1, onChanged: (bool? value){
                                          if(value != null){
                                            taskProvider.markAsDoneTask(taskProvider.tasks[index]);
                                          }
                                        }),
                                        Text(taskProvider.tasks[index].title!,style: TextStyle(fontSize: 25),)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () => {
                            taskProvider
                                .deleteTask(taskProvider.tasks[index].id!)
                          },
                        ),
                      ],
                    );
                  },
                )
                // child: Column(
                //   children: [
                //     Text(provider.name),
                //     ElevatedButton(
                //       onPressed: () {
                //         provider.name = "Text Changed By Provider  !!!";
                //       },
                //       child: Text('Create Package'),
                //     )
                //   ],
                // ),
                ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              height: 50,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => CreateTaskScreen(),
                  );
                },
                child: const Center(
                  child: Text('Create Task'),
                ),
              ),
            ),
          ),
          Scaffold(
            body: Container(
                color: Colors.black38,
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List<Widget>.generate(notesProvider.notes.length,
                      (index) {
                    return Stack(
                      children: [
                        InkWell(
                          child: Container(
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notesProvider.notes[index].title ?? "",
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    Text(
                                      notesProvider.notes[index].description ??
                                          "",
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    Text(
                                      notesProvider.notes[index].dateTime ?? "",
                                      style:
                                          const TextStyle(color: Colors.indigo),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // provider.name = "Text Changed By Provider  !!!";
                                        notesProvider.deleteNote(
                                            notesProvider.notes[index].id!);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () => {
                            // notesProvider.deleteTask(notesProvider.notes[index].id!)
                          },
                        ),
                      ],
                    );
                  }),
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              height: 50,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => CreateNoteScreen(),
                  );
                },
                child: const Center(
                  child: Text('Create Note'),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
