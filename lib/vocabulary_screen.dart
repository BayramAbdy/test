import 'dart:developer';

//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen>
    with TickerProviderStateMixin {
  //final AudioPlayer _audioPlayer = AudioPlayer();
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  int pointCount = 10;

  late AnimationController _pointAnimationController;
  late Animation<Offset> _pointAnimation;
  bool _showAnimatedCoin = false;
  GlobalKey _pointCounterKey = GlobalKey();
  Offset? _animationStratPosition;
  Offset? _animationEndPosition;

  List<Map<String, dynamic>> question = [
    {
      'word': 'motivation',
      'description': 'The reason or enthusiasm for doing something',
      'answer': ['kesgitlemek', 'höwes', 'başarnyklar', 'talaplar'],
      'correct': 'höwes',
    },
    {
      'word': 'expectations',
      'description':
          'Beliefs about what should happen or what something should achieve',
      'answer': ['başarnyk', 'höwes', 'kesgitlemek', 'talaplar'],
      'correct': 'talaplar',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pointAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _pointAnimationController.dispose();
    super.dispose();
  }

  void _handleAnswerSelection(String answer) async {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
    });

    bool isCorrect = answer == question[currentQuestionIndex]['correct'];

    if (isCorrect) {
      await _startCoinAnimation(answer);

      await _playSuccessSound();

      setState(() {
        pointCount++;
      });
    } else {
      await _vibrate();
    }
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      if (currentQuestionIndex < question.length - 1) {
        currentQuestionIndex++;
      } else {
        currentQuestionIndex = 0;
      }
      selectedAnswer = null;
      isAnswered = false;
    });
  }

  Future<void> _startCoinAnimation(String answer) async {
    await Future.delayed(Duration(milliseconds: 100));

    final screenSize = MediaQuery.of(context).size;

    _animationStratPosition = Offset(
      screenSize.width / 2,
      screenSize.height * 0.7,
    );

    final RenderBox? pointCounterBox =
        _pointCounterKey.currentContext?.findRenderObject() as RenderBox?;

    if (pointCounterBox != null) {
      final pointCounterPosition = pointCounterBox.localToGlobal(Offset.zero);
      _animationEndPosition = Offset(
        pointCounterPosition.dx + (pointCounterBox.size.width / 2),
        pointCounterPosition.dy + (pointCounterBox.size.height / 2),
      );
    } else {
      _animationEndPosition = Offset(screenSize.width - 60, 50);
    }

    _pointAnimation = Tween<Offset>(
      begin: _animationStratPosition!,
      end: _animationEndPosition!,
    ).animate(
      CurvedAnimation(
        parent: _pointAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    setState(() {
      _showAnimatedCoin = true;
    });

    _pointAnimationController.forward().then((_) {
      setState(() {
        _showAnimatedCoin = false;
      });
      _pointAnimationController.reset();
    });
  }

  Future<void> _playSuccessSound() async {
    try {
      SystemSound.play(SystemSoundType.click);
    } catch (error) {
      log('Error playing success sound : $error');
    }
  }

  Future<void> _vibrate() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (error) {
      log('Error vibrating : $error');
    }
  }

  Color _getAnswerButtonColor(String answer) {
    if (!isAnswered) {
      return const Color(0xFFFFFFFF);
    }
    if(answer == selectedAnswer){
      if (answer == question[currentQuestionIndex]['correct']) {
        return const Color(0xFF1FDA92);
      } else {
        return const Color(0xFFDA1F1F);
      }
    }
    return const Color(0xFFFFFFFF);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LEXICON',
          style: TextStyle(
            color: const Color(0xFF000000),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 3,
            decorationStyle: TextDecorationStyle.wavy,
          ),
        ),
        actions: [
          Container(
            key: _pointCounterKey,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              color: const Color(0xFF21B5D8),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/coin.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 6),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    pointCount.toString(),
                    style: TextStyle(
                      color: const Color(0xFFFFFFFF),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 16, top: 50),
                  color: const Color(0xFFF9F0E0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Bu sözüň näme many \n berýändigini saýlaň',
                          style: TextStyle(
                            color: const Color(0xFFC85929),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/camel.png',
                        width: 140,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  color: const Color(0xFF500072),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        question[currentQuestionIndex]['word'],
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400,
                          fontSize: 40,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        question[currentQuestionIndex]['description'],
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      isAnswered
                          ? selectedAnswer ==
                                  question[currentQuestionIndex]['correct']
                              ? Column(
                                children: [
                                  SizedBox(height: 12,),
                                  Image.asset(
                                    'assets/images/green.png',
                                    width: 45,
                                    height: 45,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 12,),
                                ],
                              )
                              : Column(
                                children: [
                                  SizedBox(height: 12,),
                                  Image.asset(
                                    'assets/images/red.png',
                                    width: 45,
                                    height: 45,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 12,),
                                ],
                              )
                          : SizedBox(height: 60),
                      Expanded(
                        child: Column(
                          children: List.generate(
                            question[currentQuestionIndex]['answer'].length,
                            (index) {
                              String answer =
                                  question[currentQuestionIndex]['answer'][index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => _handleAnswerSelection(answer),
                                    child: AnimatedContainer(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.circular(36),
                                        border: Border.all(
                                          width: 10,
                                          color: _getAnswerButtonColor(answer),
                                        ),
                                      ),
                                      duration: Duration(seconds: 2),
                                      child: Center(
                                        child: Text(
                                          question[currentQuestionIndex]['answer'][index],
                                          style: TextStyle(
                                            color: const Color(0xFF031F1D),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 150,
            left: 16,
            child: Image.asset(
              'assets/images/lampa.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          if (_showAnimatedCoin &&
              _animationStratPosition != null &&
              _animationEndPosition != null)
            AnimatedBuilder(
              animation: _pointAnimation,
              builder: (context, child) {
                return Positioned(
                  left: _pointAnimation.value.dx - 15,
                  top: _pointAnimation.value.dy - 15,
                  child: Image.asset(
                    'assets/images/coinGroup.png',
                    width: 70,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start from bottom left
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    // Create wave pattern
    var firstControlPoint = Offset(size.width * 0.8, 10);
    var firstEndPoint = Offset(size.width * 0.5, 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 0.5, 20);
    var secondEndPoint = Offset(0, 0);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    var thirdControlPoint = Offset(size.width * 0.2, 10);
    var thirdEndPoint = Offset(size.width * 0.5, 20);
    path.quadraticBezierTo(
      thirdControlPoint.dx,
      thirdControlPoint.dy,
      thirdEndPoint.dx,
      thirdEndPoint.dy,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

// class WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//
//     // Start from top-left corner (raised)
//     path.moveTo(0, 0);
//
//     // Draw straight lines to bottom-right
//     path.lineTo(0, size.height);
//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, 0); // Top-right corner (raised)
//
//     // Create wave pattern on top edge
//     var firstControlPoint = Offset(size.width * 0.25, 40); // Lower control point for dip
//     var firstEndPoint = Offset(size.width * 0.5, 20); // Middle dip (slightly below)
//     path.quadraticBezierTo(
//       firstControlPoint.dx,
//       firstControlPoint.dy,
//       firstEndPoint.dx,
//       firstEndPoint.dy,
//     );
//
//     var secondControlPoint = Offset(size.width * 0.75, 40); // Lower control point for second curve
//     var secondEndPoint = Offset(size.width, 0); // Back to top-right
//     path.quadraticBezierTo(
//       secondControlPoint.dx,
//       secondControlPoint.dy,
//       secondEndPoint.dx,
//       secondEndPoint.dy,
//     );
//
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
