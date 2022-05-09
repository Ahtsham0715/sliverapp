import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as Math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScrollController? _scrollController;
  bool lastStatus = true;
  double height = 200;

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Horizons Weather',
      home: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.blueGrey,
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.height * 0.35,
                collapsedHeight: MediaQuery.of(context).size.height * 0.13,
                centerTitle: false,
                // actions: [
                //   Center(
                //       child: DottedCircularProgressIndicatorFb(
                //     size: 30,
                //     numDots: 9,
                //     dotSize: 3,
                //     defaultDotColor: Colors.blue,
                //     currentDotColor: Colors.orange,
                //     secondsPerRotation: 1,
                //   ))
                // ],
                leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 25.0,
                    )),
                title: _isShrink
                    ? null
                    : const Text(
                        "Date: 28-04-2022",
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  title: _isShrink
                      ? SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                // Text(
                                //   "Date: 28-04-2022",
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                Text(
                                  "Subject: Cloud Computing",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Class: BSCS 8th",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                  background: SafeArea(
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Image.network(
                            "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: const [
                              // Text(
                              //   "Date: 28-04-2022",
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 24.0,
                              //   ),
                              //   textAlign: TextAlign.center,
                              // ),
                              Text(
                                "Subject: Cloud Computing",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Class: BSCS 8th",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: CustomScrollView(
            scrollBehavior: const ScrollBehavior(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        "Item: $index",
                        style: TextStyle(fontSize: 30.0),
                      )),
                    );
                  },
                  childCount: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//A cicular loading indicator made up of colored dots. The current dot circles around the dot clockwise.
class DottedCircularProgressIndicatorFb extends StatefulWidget {
  const DottedCircularProgressIndicatorFb({
    Key? key,
    required this.currentDotColor,
    required this.defaultDotColor,
    required this.numDots,
    this.size = 50,
    this.dotSize = 5,
    this.secondsPerRotation = 1,
  }) : super(key: key);

  final int numDots; //Number of dots around the dot circle
  final double size; //Width and height of the
  final double dotSize; //Diameter of each dot
  final int secondsPerRotation;
  final Color
      currentDotColor; //The color of the dot that "circles" around the indicator
  final Color defaultDotColor; //The color of the dots that aren't animated

  @override
  State<DottedCircularProgressIndicatorFb> createState() =>
      _DottedCircularProgressIndicatorFbState();
}

class _DottedCircularProgressIndicatorFbState
    extends State<DottedCircularProgressIndicatorFb>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<int> animation;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        duration: Duration(seconds: widget.secondsPerRotation), vsync: this)
      ..repeat();
    animation =
        StepTween(begin: 0, end: widget.numDots + 1).animate(animController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      // decoration: BoxDecoration(color: Colors.red), //for debugging purposes
      child: CustomPaint(
        child: Container(),
        painter: DottedCircularProgressIndicatorPainterFb(
            dotColor: widget.defaultDotColor,
            currentDotColor: widget.currentDotColor,
            percentage: 0,
            numDots: widget.numDots,
            currentDotNum: animation.value,
            dotWidth: widget.dotSize),
      ),
    );
  }
}

class DottedCircularProgressIndicatorPainterFb extends CustomPainter {
  final double percentage;
  final Color dotColor;
  final Color currentDotColor;
  final int numDots;
  final int currentDotNum;
  final double dotWidth;

  DottedCircularProgressIndicatorPainterFb(
      {required this.dotColor,
      required this.currentDotColor,
      required this.percentage,
      required this.numDots,
      required this.dotWidth,
      required this.currentDotNum});

  @override
  void paint(Canvas canvas, Size size) {
    final double smallestSide = Math.min(size.width, size.height);
    final double radius = (smallestSide / 2 - dotWidth / 2) - dotWidth / 2;
    final Offset centerPoint = Offset(size.width / 2, size.height / 2);

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = dotColor;

    Circle myCircle = Circle(radius: radius, totalNumOfDots: numDots);
    for (var i = 0; i < numDots; i++) {
      if (i == currentDotNum) {
        dotPaint.color = currentDotColor;
      } else {
        dotPaint.color = dotColor;
      }
      canvas.drawCircle(
          centerPoint - myCircle.calcDotOffsetFromCenter(i, radius),
          dotWidth,
          dotPaint);
    }
  }

  @override
  bool shouldRepaint(DottedCircularProgressIndicatorPainterFb oldDelegate) =>
      oldDelegate.currentDotNum != currentDotNum ? true : false;
}

//  Calculats the offst each dot based on the total number of dots
class Circle {
  int totalNumOfDots;
  double radius;

  Circle({required this.totalNumOfDots, required this.radius});

  Offset calcDotOffsetFromCenter(int dotNumber, double radius) {
    return Offset(_calcDotX(dotNumber), _calcDotY(dotNumber));
  }

  double _calcDotAngle(int currentDotNumber) {
    return -currentDotNumber * _calcRadiansPerDot();
  }

  double _calcRadiansPerDot() {
    return 2 * Math.pi / (totalNumOfDots);
  }

  double _calcDotX(int thisDotNum) {
    //offset from indicator circles center
    return radius * Math.sin(_calcDotAngle(thisDotNum));
  }

  double _calcDotY(int thisDotNum) {
    //offset from indicator circles center
    return radius * Math.cos(_calcDotAngle(thisDotNum));
  }
}
