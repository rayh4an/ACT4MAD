import 'package:flutter/material.dart';
import 'dart:async';
import 'package:confetti/confetti.dart';

void main() {
  runApp(HeartbeatApp());
}

class HeartbeatApp extends StatefulWidget {
  @override
  _HeartbeatAppState createState() => _HeartbeatAppState();
}

class _HeartbeatAppState extends State<HeartbeatApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ConfettiController _confettiController;
  int countdown = 10;
  Timer? _timer;
  bool isAnimating = false;
  bool showGreetings = false;
  List<String> greetings = [
    "Happy Valentine's Day! ❤️",
    "You make my heart skip a beat! 💕",
    "Love is in the air! 🌹",
    "Sending you all my love! 💖",
    "Forever and always! 💘"
  ];
  int currentGreetingIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _confettiController = ConfettiController(duration: Duration(seconds: 5));
  }

  void startCountdown() {
    _timer?.cancel(); // Reset the timer
    countdown = 10;
    isAnimating = true;
    showGreetings = false;
    _controller.repeat(reverse: true);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          _timer?.cancel();
          isAnimating = false;
          _controller.stop();
          _confettiController.play();
          showGreetings = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[50],
        appBar: AppBar(
          title: Text("❤️ VALENTINE ❤️"),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    startCountdown();
                  });
                },
                child: ScaleTransition(
                  scale: _animation,
                  child: Image.asset(
                    'assets/heart1.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Tap the heart, see the magic: $countdown",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              AnimatedOpacity(
                opacity: showGreetings ? 1.0 : 0.0,
                duration: Duration(seconds: 2),
                child: Column(
                  children: greetings
                      .map((greeting) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              greeting,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),
                            ),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 20),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 300,
                colors: [Colors.red, Colors.pink, Colors.orange, Colors.white],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
