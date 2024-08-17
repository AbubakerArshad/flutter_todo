import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/simple_provider.dart';
import 'package:todo_app/provider/task_provider.dart';
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      final now = DateTime.now();
      final dateTimeFormatter = DateFormat('dd-MMM-yyyy, hh:mm:a');
      final formattedDate = dateTimeFormatter.format(now);

      print(formattedDate);

      var task = Task(title: "Testing", isDone: 0, dateTime: formattedDate);
      // add(task);
      // _query();
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final dateTimeFormatter = DateFormat('dd-MMM-yyyy, hh:mm:a');
    final formattedDate = dateTimeFormatter.format(now);

    print(formattedDate);

    var task = Task(title: "Testing", isDone: 0, dateTime: formattedDate);
    add(task);
    _query();
  }

  Future<void> add(Task task) async {
    Map<String, dynamic> row = {
      "title": task.title,
      "isDone": task.isDone,
      "dateTime": task.dateTime
    };
    final id = await dbHelper.createTask(row);
    debugPrint('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.getAllTask();
    print('query all rows:');
    for (final row in allRows) {
      print(row.toString());
    }
  }

  final List<String> tabTitles = ['Tasks', 'Notes'];

  bool isChecked = false;



  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<SimpleProvider>(context);
    final task_provider = Provider.of<TaskProvider>(context);

    task_provider.loadTasks();

    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: tabTitles.map((title) => Tab(text: title)).toList(),
          ),
        ),
        body: TabBarView(children: [
          Container(
            child: ListView.builder(itemCount: task_provider.tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: [
                    InkWell(
                      child: Container(width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(task_provider.tasks[index].title! ,style: TextStyle(color: Colors.blue),),
                                Text(task_provider.tasks[index].isDone == 1 ? "Done" : "Pending" ,style: TextStyle(color: Colors.red),),
                                    ElevatedButton(
                                      onPressed: () {
                                        // provider.name = "Text Changed By Provider  !!!";
                                        task_provider.markAsDoneTask(task_provider.tasks[index]);
                                      },
                                      child: Text('Mark as Done'),
                                    )
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () =>{

                      task_provider.deleteTask(task_provider.tasks[index].id!)
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
          Container(
            color: Colors.black38,
          ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 50,
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: ElevatedButton(
            onPressed: () async {
              final result = await showDialog(
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

    );
  }
}
