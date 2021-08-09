import 'package:card_app/card_counter.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Ap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Super app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _players = 5;
  int _life = 40;

  void _updatePlayers(int updatedPlayers) {
    setState(() {
      _players = updatedPlayers;
    });

    Navigator.pop(context);
  }

  TextButton createPlayerButton(int value) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
      ),
      icon: Icon(Icons.person),
      onPressed: () => _updatePlayers(value),
      label: Text(value.toString()),
    );
  }

  void _updateLife(int updatedLife) {
    setState(() {
      _life = updatedLife;
    });

    Navigator.pop(context);
  }

  TextButton createLifeButton(int value) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
      ),
      icon: Icon(Icons.favorite),
      onPressed: () => _updateLife(value),
      label: Text(value.toString()),
    );
  }

  Route<Object?> _dialogBuilderPlayers(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            createPlayerButton(2),
            createPlayerButton(3),
            createPlayerButton(4),
            createPlayerButton(5)
          ],
        ),
      ),
    );
  }

  Route<Object?> _dialogBuilderLife(BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            createLifeButton(20),
            createLifeButton(30),
            createLifeButton(40),
          ],
        ),
      ),
    );
  }

  GridView createView() {
    return GridView.count(
      crossAxisCount: _players == 2 ? 1 : 2,
      shrinkWrap: true,
      childAspectRatio: calculateChildAspectRatio(context),
      children: List.generate(_players, (index) {
        return Container(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          child: CardCounter(
            startValue: _life,
            cardIndex: index,
            players: _players,
          ),
        );
      }),
    );
  }

  Widget something() {
    return StaggeredGridView.countBuilder(
        shrinkWrap: false,
        crossAxisCount: _players == 2 ? 2 : 4,
        itemCount: _players,
        itemBuilder: (BuildContext context, int index) => Container(
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
              child: CardCounter(
                startValue: _life,
                cardIndex: index,
                players: _players,
              ),
            ),
        staggeredTileBuilder: (int index) {
          if (_players == 2) {
            return new StaggeredTile.extent(
              2,
              MediaQuery.of(context).size.width * 0.95,
            );
          }
          if (_players == 3 || _players == 4) {
            if (_players == 3 && index == 2) {
              return new StaggeredTile.extent(
                4,
                MediaQuery.of(context).size.width,
              );
            }
            return new StaggeredTile.extent(
              2,
              MediaQuery.of(context).size.width,
            );
          }
          if (_players == 5) {
            if (index == 4) {
              return new StaggeredTile.extent(
                4,
                (1 / 2) * MediaQuery.of(context).size.width,
              );
            }

            return new StaggeredTile.extent(
              2,
              0.7 * MediaQuery.of(context).size.width,
            );
          }
          return new StaggeredTile.extent(
            2,
            (1 / 2) * MediaQuery.of(context).size.width,
          );
        });
  }

  double calculateChildAspectRatio(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    if (_players == 5) {
      return width / (height / 1.5);
    }

    if (_players == 2) {
      return width / (height / 2);
    }

    return width / height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child: Center(child: Text('App')),
              ),
              ListTile(
                title: Text('Set players'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).restorablePush(_dialogBuilderPlayers);
                },
              ),
              ListTile(
                title: Text('Set life'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).restorablePush(_dialogBuilderLife);
                },
              ),
            ],
          ),
        ),
        body: something());
  }
}
