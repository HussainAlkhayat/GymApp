
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}
Map<int, Color> color =
{
50:Color.fromRGBO(159,49,177, .1),
100:Color.fromRGBO(159,49,177, .2),
200:Color.fromRGBO(159,49,177, .3),
300:Color.fromRGBO(159,49,177, .4),
400:Color.fromRGBO(159,49,177, .5),
500:Color.fromRGBO(159,49,177, .6),
600:Color.fromRGBO(159,49,177, .7),
700:Color.fromRGBO(159,49,177, .8),
800:Color.fromRGBO(159,49,177, .9),
900:Color.fromRGBO(159,49,177, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF9F31B1, color);
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your applicatrion.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: colorCustom,
        fontFamily: 'Roboto',
      ),
      home: const WorkoutListScreen(),
    );
  }
}
class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  List<WorkoutItem> _workoutItems = [];

  Future<void> _addItem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final bytes = await file.readAsBytes();

    final name = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => _AddWorkoutDialog(),
    );

    if (name == null) return;

    final item = WorkoutItem(name: name, imageBytes: bytes);
    setState(() => _workoutItems.add(item));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
      body: ListView.builder(
        itemCount: _workoutItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _workoutItems[index];
          return ListTile(
            leading: Image.memory(item.imageUint8List),
            title: Text(item.name),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WorkoutItem {
  final String name;
  final List<int> imageBytes;

  const WorkoutItem({required this.name, required this.imageBytes});

  Uint8List get imageUint8List => Uint8List.fromList(imageBytes);
}

class _AddWorkoutDialog extends StatefulWidget {
  const _AddWorkoutDialog({Key? key}) : super(key: key);

  @override
  _AddWorkoutDialogState createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<_AddWorkoutDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Workout'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter the name of the workout',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_nameController.text),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
