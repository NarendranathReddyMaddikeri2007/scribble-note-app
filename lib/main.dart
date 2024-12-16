import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bloc/todos_bloc/todos_bloc.dart';
import 'cubit/page_view_cubit.dart';
import 'cubit/secrets_cubit.dart';
import 'cubit/settings_cubit.dart';
import 'models/notes/notes.dart';
import 'models/settings/settings.dart';
import 'bloc/notes_bloc/notes_bloc.dart';
import 'models/todos/todos.dart';
import 'presentation/themes/themes.dart';
import 'presentation/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'services/hive_database.dart';
import 'services/settings_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Optimal directory path to store the notes
  final directory = await getApplicationDocumentsDirectory();
  //Initialize the hive database
  await Hive.initFlutter(directory.path);
  //Custom object for hive
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(TodosAdapter());
  //Initialization of boxes (open the box)
  Box<Notes> notesBox = await HiveNotesDatabase.openBox('notes') as Box<Notes>;
  Box<Notes> secretNotesBox =
      await HiveNotesDatabase.openBox('secret') as Box<Notes>;
  Box<Todos> todosBox = await HiveTodosDatabase.openBox('todos');
  Box<Settings> settingsBox = await HiveSettingsDatabase.openBox('settings');
  HiveSettingsDatabase(box: settingsBox).initializeSettings();
  runApp(
    MyApp(
        notesBox: notesBox,
        secretsBox: secretNotesBox,
        todosBox: todosBox,
        settingsbox: settingsBox),
  );
}

class MyApp extends StatelessWidget {
  final Box<Notes> notesBox;
  final Box<Notes> secretsBox;
  final Box<Todos> todosBox;
  final Box<Settings> settingsbox;
  const MyApp(
      {super.key,
      required this.notesBox,
      required this.secretsBox,
      required this.todosBox,
      required this.settingsbox});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                NotesBloc(hiveDatabase: HiveNotesDatabase(box: notesBox))
                  ..add(LoadNotesEvent())),
        BlocProvider(
          create: (context) => SettingsCubit(
            settingsDatabase: HiveSettingsDatabase(box: settingsbox),
          ),
        ),
        BlocProvider(
            create: (context) =>
                TodosBloc(hiveDatabase: HiveTodosDatabase(box: todosBox))
                  ..add(LoadTodoEvent())),
        BlocProvider(
          create: (context) => SecretsCubit(),
        ),
        BlocProvider(
          create: (context) => PageViewCubit(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, Settings>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
