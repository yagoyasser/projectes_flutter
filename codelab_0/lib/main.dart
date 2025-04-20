import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  var paraulaAleatoria = WordPair.random();

  void getNext() {
    paraulaAleatoria = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(paraulaAleatoria)) {
      favorites.remove(paraulaAleatoria);
    } else {
      favorites.add(paraulaAleatoria);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var indexSeleccionat = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (indexSeleccionat) {
      case 0:
        page = pagGeneracioParaules();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('No hi ha cap index per a $indexSeleccionat');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: indexSeleccionat,
                  onDestinationSelected: (value) {
                    setState(() {
                      indexSeleccionat = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class pagGeneracioParaules extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var paraulaActual = appState.paraulaAleatoria;

    IconData icona;
    if (appState.favorites.contains(paraulaActual)) {
      icona = Icons.favorite;
    } else {
      icona = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('Una paraula aleatòria en anglés:'),
          Paraula(paraulaActual: paraulaActual),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icona),
                label: Text('M\'agrada'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // print('Botó premut!'); // Es mostra al terminal
                  appState.getNext();
                },
                child: Text('Següent'),
              ),
            ],
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
      color: tema.colorScheme
          .primary, // El color* està indicat a la classe MyApp ... colorScheme
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          paraulaActual.asLowerCase,
          style: estil,
          semanticsLabel: "${paraulaActual.first} ${paraulaActual.second}",
        ),
      ),
    );
  }
}
