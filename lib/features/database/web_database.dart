import 'package:database_web/features/database/model/boxes.dart';
import 'package:database_web/features/database/model/person.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter(); //initialize hive
  Hive.registerAdapter(
      PersonAdapter()); // register the adapter for the Person class
  boxPersons = await Hive.openBox<Person>(
      'PersonBox'); // open the Hive box for storing Person objects
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Database(),
    );
  }
}

class Database extends StatefulWidget {
  const Database({super.key});

  @override
  State<Database> createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database"),
        centerTitle: true,
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter name',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _ageController,
            decoration: const InputDecoration(
              hintText: 'Enter age',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                //add persons to the database
                boxPersons.put(
                    'key_${_nameController.text}',
                    Person(
                      name: _nameController.text,
                      age: int.parse(_ageController.text),
                    ));
                //clear the textfield
                _nameController.clear();
                _ageController.clear();
              });
            },
            child: const Text('Add'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: boxPersons.length,
              itemBuilder: (context, index) {
                Person? person = boxPersons.getAt(index);

                return ListTile(
                  title: Text(person!.name),
                  subtitle: Text('Age: ${person.age}'),
                  trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          boxPersons.deleteAt(index);
                        });
                      },
                      icon: const Icon(Icons.delete)),
                );
              },
            ),
          ),
          //clear all the data
          TextButton.icon(
              onPressed: () {
                setState(() {
                  boxPersons.clear();
                });
              },
              icon: const Icon(Icons.clear),
              label: const Text('Delete All')),
        ],
      ),
    );
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
