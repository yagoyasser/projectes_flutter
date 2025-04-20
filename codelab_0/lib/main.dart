import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var paraulaActual = WordPair.random();

  void getNext() {
    paraulaActual = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var paraulaActual = appState.paraulaActual;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Una paraula aleatòria en anglés:'),
          Paraula(paraulaActual: paraulaActual),

          ElevatedButton(
            onPressed: () {
              print('Botó premut!'); // Es mostra al terminal
              appState.getNext();
            },
            child: Text('Següent'),
          ),

        ],
      ),
    );
  }
}

class Paraula extends StatelessWidget {
  const Paraula({
    super.key,
    required this.paraulaActual,
  });

  final WordPair paraulaActual;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final estil = tema.textTheme.displayMedium!.copyWith(
      color: tema.colorScheme.onPrimary,
    );

    return Card(
      color: tema.colorScheme.primary, // El color* està indicat a la classe MyApp ... colorScheme
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          paraulaActual.asLowerCase,
          style: estil,
          semanticsLabel: "${paraulaActual.first} ${paraulaActual.second}",),
      ),
    );
  }
}