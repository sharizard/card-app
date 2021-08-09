import 'package:flutter/material.dart';

class CardCounter extends StatefulWidget {
  final int players;
  final int cardIndex;
  final int startValue;

  const CardCounter({
    Key? key,
    required this.startValue,
    required this.cardIndex,
    required this.players,
  }) : super(key: key);

  @override
  _CardCounterState createState() => _CardCounterState();
}

class _CardCounterState extends State<CardCounter> {
  late int _counter;

  @override
  void initState() {
    setState(() {
      _counter = widget.startValue;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CardCounter oldWidget) {
    if (widget.startValue != oldWidget.startValue) {
      setState(() {
        _counter = widget.startValue;
      });
      super.didUpdateWidget(oldWidget);
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  TextButton _createButton(String text, VoidCallback onPressed) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 40, color: Colors.black),
      ),
      onPressed: onPressed,
      onLongPress: onPressed,
      child: Text(text),
    );
  }

  int calculateQuarterTurns() {
    final players = widget.players;
    final index = widget.cardIndex;

    if (players == 2 && index == 0) {
      return 2;
    }

    if (players == 3) {
      if (index == 0) {
        return 1;
      }

      if (index.isOdd) {
        return 3;
      }
    }

    if (players == 5 || players == 4) {
      if (index == 0 || index == 2) {
        return 1;
      }

      if (index.isOdd) {
        return 3;
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: calculateQuarterTurns(),
      child: Container(
        child: Stack(
          children: [
            Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _createButton("-", _decrementCounter),
                    Text(
                      _counter.toString(),
                      style: TextStyle(fontSize: 80),
                    ),
                    _createButton("+", _incrementCounter),
                  ],
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.restart_alt),
                      onPressed: () {
                        setState(() {
                          _counter = widget.startValue;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _counter = 0;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
