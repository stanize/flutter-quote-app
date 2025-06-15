import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
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
  List<Map<String, String>> quotes = [];
  String currentQuote = '';
  double _opacity = 1.0;

  final Duration fadeOutDuration = Duration(milliseconds: 1500);
  final Duration fadeInDuration = Duration(milliseconds: 1500);
  final Duration delayBetween = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    loadQuotes();
  }

  Future<void> loadQuotes() async {
    final String jsonString = await rootBundle.loadString('assets/quotes.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      quotes = jsonData.cast<Map<String, dynamic>>()
          .map((e) => {'quote': e['quote'] as String, 'author': e['author'] as String})
          .toList();
      currentQuote = formatQuote(quotes[Random().nextInt(quotes.length)]);
    });
  }

  String formatQuote(Map<String, String> quoteData) {
    return '"${quoteData['quote']}"\n\n- ${quoteData['author']}';
  }

  void nextQuote() async {
    setState(() {
      _opacity = 0.0;
    });

    await Future.delayed(fadeOutDuration + delayBetween);

    setState(() {
      currentQuote = formatQuote(quotes[Random().nextInt(quotes.length)]);
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
        onTap: quotes.isNotEmpty ? nextQuote : null,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: quotes.isEmpty
                ? CircularProgressIndicator()
                : AnimatedOpacity(
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
