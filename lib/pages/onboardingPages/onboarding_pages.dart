import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try1_something/onboarding_values.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPages extends StatefulWidget {
  const OnboardingPages({Key? key}) : super(key: key);

  @override
  State<OnboardingPages> createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages> {
  int currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    setData();
  }

  Future<void> setData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('initScreen', 1);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          // color: Colors.red,
          child: Stack(
            children: [
              //upside down triagnle
              CustomPaint(
                size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewPadding.top),
                painter: drawUpsideDownTriangle(),
              ),

              //background right angle triangle
              CustomPaint(
                // MediaQuery.of(context).size.width
                size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewPadding.top),
                painter: drawRightAngleTriangleShape(),
              ),

              //main column that holds all the data
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  //top box
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ).copyWith(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${currentIndex + 1}/3',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(5),
                          // color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            splashColor: Color.fromARGB(97, 104, 58, 183),
                            onTap: () {
                              if (currentIndex !=
                                  (onboardingValues.length - 1)) {
                                _controller!.animateToPage(
                                  onboardingValues.length,
                                  duration: Duration(
                                    milliseconds: 400,
                                  ),
                                  curve: Curves.bounceIn,
                                );
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 2),
                              child: Text(
                                'Skip',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //center container
                  Container(
                    height: 426,
                    child: PageView.builder(
                      controller: _controller,
                      // allowImplicitScrolling: false,

                      physics: BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemCount: onboardingValues.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                onboardingValues[index].title!,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              Text(
                                onboardingValues[index].subTitle!,
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Image.asset(
                              //   onboardingValues[index].imgPath!,
                              //   width: MediaQuery.of(context).size.width,
                              //   height: 230,
                              // ),
                              SvgPicture.asset(
                                onboardingValues[index].imgPath!,
                                semanticsLabel: onboardingValues[index].title!,
                                width: MediaQuery.of(context).size.width,
                                height: 230,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width - 60,
                                  child: Text(
                                    onboardingValues[index].description!,
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  //bottom column
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingValues.length,
                          (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              width: currentIndex == index ? 25 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(199, 104, 58, 183),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      //container to give margins
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ).copyWith(bottom: 30),
                        child: Material(
                          borderRadius: BorderRadius.circular(13),
                          color: const Color.fromARGB(199, 104, 58, 183),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(13),
                            splashColor: Color.fromARGB(73, 255, 255, 255),
                            onTap: () {
                              if (currentIndex == onboardingValues.length - 1) {
                                Get.toNamed('/firstPage');
                              } else {
                                setState(() {
                                  _controller!.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.bounceIn,
                                  );
                                  print(
                                      'current index  from continue $currentIndex');
                                });
                              }
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Center(
                                child: Text(
                                  currentIndex == onboardingValues.length - 1
                                      ? 'Continue'
                                      : 'Next',
                                  style: Theme.of(context).textTheme.button!,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class drawRightAngleTriangleShape extends CustomPainter {
  Paint? painter;
  drawRightAngleTriangleShape() {
    painter = Paint()
      ..color = Color.fromARGB(17, 103, 58, 183)
      ..style = PaintingStyle.fill;
  }
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(size.width, 0);

    path.lineTo(0, size.height);
    path.lineTo(size.height, size.height);
    path.close();

    canvas.drawPath(path, painter!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class drawUpsideDownTriangle extends CustomPainter {
  Paint? painter;

  drawUpsideDownTriangle() {
    painter = Paint()
      ..color = Color.fromARGB(17, 0, 0, 0)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width / 3, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, painter!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
