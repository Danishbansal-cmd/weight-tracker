import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try1_something/onboarding_values.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                    Text(
                      'Skip',
                      style: Theme.of(context).textTheme.headline5,
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
                  itemCount: onboradingValues.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            onboradingValues[index].title!,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            onboradingValues[index].subTitle!,
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            onboradingValues[index].imgPath!,
                            width: MediaQuery.of(context).size.width,
                            height: 230,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 60,
                              child: Text(
                                onboradingValues[index].description!,
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
                      onboradingValues.length,
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
                  GestureDetector(
                    onTap: () {
                      if (currentIndex == onboradingValues.length - 1) {
                        Get.toNamed('/firstPage');
                      } else {
                        setState(() {
                          _controller!.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.bounceIn,
                          );
                          print('current index  from continue $currentIndex');
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ).copyWith(bottom: 30),
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Color.fromARGB(199, 104, 58, 183),
                      ),
                      child: Center(
                        child: Text(
                          currentIndex == onboradingValues.length - 1
                              ? 'Continue'
                              : 'Next',
                          style: Theme.of(context).textTheme.button!,
                        ),
                      ),
                    ),
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
