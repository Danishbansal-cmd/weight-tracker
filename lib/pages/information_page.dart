import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class InformationPage extends StatefulWidget {
  InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  //
  //initializing getx controller
  final informationPageController = Get.put(InformationPageController());

  PageController? _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    // setData();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    controller: _controller,
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Select your height in Centimeters',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Obx(
                                  () => NumberPicker(
                                    axis: Axis.horizontal,
                                    decoration: BoxDecoration(
                                      // color: Colors.transparent,
                                      border: Border.all(
                                        color: Color.fromARGB(255, 80, 80, 80),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    selectedTextStyle: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    itemHeight: 100,
                                    itemWidth: 100,
                                    value: informationPageController
                                        .getHeightValue,
                                    minValue: 50,
                                    maxValue: 300,
                                    onChanged: (value) =>
                                        informationPageController
                                            .setHeightValue(value),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Text(
                                  'Select your weight in Pounds',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Obx(
                                  () => NumberPicker(
                                    axis: Axis.horizontal,
                                    decoration: BoxDecoration(
                                      // color: Colors.transparent,
                                      border: Border.all(
                                        color: Color.fromARGB(255, 80, 80, 80),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    selectedTextStyle: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    itemHeight: 100,
                                    itemWidth: 100,
                                    value: informationPageController
                                        .getWeightValue,
                                    minValue: 50,
                                    maxValue: 650,
                                    onChanged: (value) =>
                                        informationPageController
                                            .setWeightValue(value),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text('this is second page'),
                              ],
                            );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 30,
                        ).copyWith(right: 30),
                        child: Material(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(9),
                          child: InkWell(
                            onTap: () {
                              print('asfsdf');
                              if (_currentIndex == 0) {
                                setState(() {
                                  _controller!.nextPage(
                                    duration: const Duration(
                                      milliseconds: 400,
                                    ),
                                    curve: Curves.bounceIn,
                                  );
                                });
                              }
                              if (_currentIndex == 1) {
                                Get.offAllNamed('/homePage');
                              }
                            },
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width / 3,
                              padding: EdgeInsets.symmetric(
                                // horizontal: 40,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(),
                              child: Center(
                                child: Text(
                                  _currentIndex == 0 ? 'Next' : 'Continue',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InformationPageController extends GetxController {
  RxInt _heightValue = 170.obs;
  RxInt _weightValue = 120.obs;

  //getters and setters
  int get getHeightValue {
    return _heightValue.value;
  }

  int get getWeightValue {
    return _weightValue.value;
  }

  setHeightValue(int value) {
    _heightValue.value = value;
  }

  setWeightValue(int value) {
    _weightValue.value = value;
  }
}
