import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/task.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

      var task = Task( title: "Testing", isDone: 0, dateTime: formattedDate);
      add(task);
      _query();
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
  final List<List<String>> tabData = [
    ['Item 1', 'Item 2', 'Item 3'],
    ['Item A', 'Item B', 'Item C'],
    ['Item X', 'Item Y', 'Item Z'],
  ];


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
        length: tabTitles.length,
        child: Scaffold(
            appBar: AppBar(

            bottom: TabBar(
            tabs: tabTitles.map((title) => Tab(text: title)).toList(),
    ),
    ),
    body: TabBarView(
    children: [
      Container(color: Colors.black54,),
      Container(color: Colors.black38,)
    ]
    ),
    ),
    );
  }

}
