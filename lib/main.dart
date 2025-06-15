import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(InspireQuoteApp());
}

class InspireQuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspirational Quotes',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final List<String> quotes = [
    "Believe you can and you're halfway there.",
    "The best time to plant a tree was 20 years ago. The second best time is now.",
    "You miss 100% of the shots you don’t take.",
    "Success is not final, failure is not fatal: It is the courage to continue that counts.",
    "Your limitation—it’s only your imagination.",
  ];

  String currentQuote = "";
  double _opacity = 1.0;

  final Duration fadeOutDuration = Duration(milliseconds: 1500);
  final Duration fadeInDuration = Duration(milliseconds: 1500);
  final Duration delayBetween = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    currentQuote = quotes[Random().nextInt(quotes.length)];
  }

  void nextQuote() async {
    // Fade out
    setState(() {
      _opacity = 0.0;
    });

    // Wait for fade-out to complete
    await Future.delayed(fadeOutDuration + delayBetween);

    // Change the quote
    setState(() {
      currentQuote = quotes[Random().nextInt(quotes.length)];
    });

    // Fade in
    setState(() {
      _opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Inspiration'),
      ),
      body: InkWell(
        onTap: nextQuote,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: _opacity == 0.0 ? fadeOutDuration : fadeInDuration,
              curve: Curves.easeInOut,
              child: Text(
                currentQuote,
                key: ValueKey(currentQuote),
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
