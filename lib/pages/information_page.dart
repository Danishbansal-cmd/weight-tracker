import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try1_something/pages/home_page.dart';

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
    // _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //initializing homepage getx controller
    final homePageController = Get.put(HomePageController());
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 20.0,),
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
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // text
                                  Text(
                                    'Select Your Gender',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //text
                                  const SizedBox(
                                    width: 290,
                                    child: Text(
                                      "Help us know you better. It will be easy for us to give you some tips depending on your information. Knowing your gender is the first important step.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //image row
                                  Container(
                                    // color: Colors.red,
                                    // padding: const EdgeInsets.symmetric(horizontal: 30,),
                                    child: Row(
                                      children: [
                                        imageBox("assets/gender/female.png"),
                                        imageBox("assets/gender/male.png"),
                                      ],
                                    ),
                                  ),
                                  //male and female buttons row
                                  Container(
                                    color: Colors.red,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            informationPageController.setFemalValueSelected(true);
                                          },
                                          child: maleFemaleButtons(
                                              informationPageController
                                                  .getFemaleValueSelected,
                                              "Female"),
                                        ),
                                        maleFemaleButtons(
                                            informationPageController
                                                .getMaleValueSelected,
                                            "Male"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : index == 1
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Select your height in Centimeters',
                                      style:
                                          Theme.of(context).textTheme.headline4,
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
                                            color:
                                                Color.fromARGB(255, 80, 80, 80),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        selectedTextStyle: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                      style:
                                          Theme.of(context).textTheme.headline4,
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
                                            color:
                                                Color.fromARGB(255, 80, 80, 80),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        selectedTextStyle: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //testing image
                                    Image.asset("assets/gender/male.png"),
                                    Text(
                                      'Your Body Mass Index is',
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      ((informationPageController
                                                      .getWeightValue *
                                                  0.453592) /
                                              ((informationPageController
                                                          .getHeightValue /
                                                      100) *
                                                  (informationPageController
                                                          .getHeightValue /
                                                      100)))
                                          .toStringAsFixed(1),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  ],
                                );
                    },
                  ),
                ),
                //bottom next button
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
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('moreinfo')
                                    .doc('aboutdata')
                                    .update({
                                  'height':
                                      informationPageController.getHeightValue,
                                });
                                homePageController.addWeight(
                                    (informationPageController.getWeightValue)
                                        .toDouble());
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

  Widget imageBox(String path) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      height: (MediaQuery.of(context).size.width - 60),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.asset(
          path,
        ),
      ),
    );
  }

  Widget maleFemaleButtons(bool isSelectedBool, String genderName) {
    return Stack(
      children: [
        //main button
        Container(
          height: 55,
          width: (MediaQuery.of(context).size.width - 75) / 2,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              genderName,
              style: Theme.of(context).textTheme.button!.copyWith(
                    letterSpacing: 0.2,
                    fontSize: 22,
                  ),
            ),
          ),
        ),
        //selected positioned check button
        Obx(
          () => Visibility(
            visible: isSelectedBool,
            child: Positioned(
              right: 20,
              top: 17,
              child: SizedBox(
                height: 20,
                width: 20,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(
                    "assets/icons/check.png",
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InformationPageController extends GetxController {
  RxInt _heightValue = 170.obs;
  RxInt _weightValue = 120.obs;
  RxBool _femaleValueSelected = false.obs;
  RxBool _maleValueSelected = false.obs;

  //getters and setters
  int get getHeightValue {
    return _heightValue.value;
  }

  int get getWeightValue {
    return _weightValue.value;
  }

  bool get getFemaleValueSelected {
    return _femaleValueSelected.value;
  }
  bool get getMaleValueSelected {
    return _maleValueSelected.value;
  }

  setHeightValue(int value) {
    _heightValue.value = value;
  }

  setWeightValue(int value) {
    _weightValue.value = value;
  }

  setMaleValueSelected(bool value) {
    _femaleValueSelected.value = false;
    _maleValueSelected.value = value;
  }
  setFemalValueSelected(bool value) {
    _maleValueSelected.value = false;
    _femaleValueSelected.value = value;
  }
}
