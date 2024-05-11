import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final todoController = TextEditingController();
  
  void addToDo() async {
  if (todoController.text.trim().isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Text("Empty title"),
  duration: Duration(seconds: 2),
  ));
  return;
  }
  await saveTodo(todoController.text);
  setState(() {
  todoController.clear();
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("List of QuickTasks"),
      backgroundColor: Color.fromARGB(255, 233, 166, 23),
      foregroundColor: Color.fromARGB(255, 255, 255, 255),
      centerTitle: true,
    ),
    body: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: todoController,
                  decoration: InputDecoration(
                    labelText: "New QuickTask",
                    labelStyle: TextStyle(color: Colors.blueAccent)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: addToDo,
                child: Text("ADD")),
            ],
          )),
    Expanded(
      child: FutureBuilder<List<ParseObject>>(
        future: getTodo(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator()),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error..."),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Text("No Data..."),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                      //*************************************
                      //Get Parse Object Values
                        final varTodo = snapshot.data![index];
                        final varTitle = varTodo.get<String>('title')!;
                        //final varDuedate =  varTodo.get<DateTime>('duedate')!.toLocal();
                        //final varDuedate =  DateFormat('dd-Mon-yyyy HH:mm:ss').format(varTodo.get<DateTime>('duedate')!.toLocal());
                        final varDuedate =  DateFormat.yMMMMEEEEd().add_jms().format(varTodo.get<DateTime>('duedate')!.toLocal());
                        final varDone =  varTodo.get<bool>('status')!;
                        //*************************************

                        return ListTile(
                          title: Text(varTitle),
                          subtitle: Text('Due Date: ' + varDuedate.toString()),
                          leading: CircleAvatar(
                            child: Icon(
                              varDone ? Icons.check : Icons.pending),
                              backgroundColor:
                                varDone ? Colors.green : Color.fromARGB(255, 243, 72, 33),
                              foregroundColor: Colors.white,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: varDone,
                                onChanged: (value) async {
                                  await updateTodo(
                                    varTodo.objectId!, value!);
                                  setState(() {
                                    //Refresh UI
                                  });
                                }),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(169, 81, 80, 80),
                                ),
                                onPressed: () async {
                                  await deleteTodo(varTodo.objectId!);
                                  setState(() {
                                    final snackBar = SnackBar(
                                      content: Text("Todo deleted!"),
                                      duration: Duration(seconds: 2),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  });
                                },
                              )
                            ],
                          ),
                        );
                      });
                  }
                }
              }))
        ],
      ),
    );
  }

  Future<void> saveTodo(String title) async {
    final dtnow = DateTime.now();
    final dtdue = dtnow.add(const Duration(hours: 168));
    final todo = ParseObject('QuickTask')..set('title', title)..set('duedate', dtdue)..set('status', false);
    await todo.save();
  }

  Future<List<ParseObject>> getTodo() async {
    QueryBuilder<ParseObject> queryTodo = QueryBuilder<ParseObject>(ParseObject('QuickTask'));
    final ParseResponse apiResponse = await queryTodo.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTodo(String id, bool done) async {
    var todo = ParseObject('QuickTask')..objectId = id..set('status', true);
    await todo.save();
  }

  Future<void> deleteTodo(String id) async {
    var todo = ParseObject('QuickTask')..objectId = id;
    await todo.delete();
  }
} 