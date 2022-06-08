import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:try1_something/functions/my_drawer.dart';
import 'package:try1_something/main.dart';
import 'package:try1_something/models/user_model.dart';
import 'package:try1_something/models/weight_model.dart';
import 'package:try1_something/pages/login_page.dart';
import 'package:try1_something/pages/settings.dart';
import 'package:try1_something/utils/themes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String weightValue = '';
  // double testing = 2334;
  TextEditingController weightController = TextEditingController();
  // late Stream<QuerySnapshot> snapshot;
  bool isLoading = true;
  bool isLoading2 = true;
  FocusNode mynode = new FocusNode();
  // List<dayAndWeightDataModel> dayAndWeightData = [];

  //

  final SettingsPageController settingsPageController =
      Get.put(SettingsPageController());
  //initializing homepage getx controller
  final homePageController = Get.put(HomePageController());

  String? unit;

  @override
  void initState() {
    isLoading = true;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      Future.delayed(
        Duration(seconds: 2),
        () {
          setState(() {
            isLoading = false;
          });
        },
      );
      Future.delayed(
        Duration(seconds: 6),
        () {
          // print('dayAndWeightDatalength ${dayAndWeightData!.length}');
          setState(() {
            isLoading2 = false;
          });
        },
      );
      super.initState();
    });

    //IMPORTANT METHOD
    //GETTING DATA FROM SERVER (FIRST METHOD)
    // final _auth = FirebaseAuth.instance.currentUser;
    // final CollectionReference firebaseFirestore = FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(user!.uid)
    //     .collection("weights");
    // firebaseFirestore.get().then(
    //       (value) => value.docs.forEach((element) {
    //         homePageController.dayAndWeightData.add(
    //           dayAndWeightDataModel(
    //             day: element.id.substring(8, 10),
    //             weight: element['weight'],
    //           ),
    //         );
    //         print('each data ${element['weight']}');
    //         print('each data id ${element.id.runtimeType}');
    //       }),
    //     );
    // print('dayAndWeightData ${homePageController.dayAndWeightData}');

    // setState(() {

    // });

    // GETTING ID METHOD
    // final _auth = FirebaseAuth.instance.currentUser;
    // final firebaseFirestore = FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(_auth!.uid)
    //     .collection("weights");
    // firebaseFirestore.get().then((value) => {
    //       if (value.docs.isNotEmpty)
    //         {
    //           for (int i = 0; i < value.docs.length; i++)
    //             {
    //               print(value.docs[i].id),
    //             }
    //         },
    //     });

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //
    setState(() {});
    final _colorScheme = Theme.of(context).colorScheme;
    final _textScheme = Theme.of(context).textTheme;
    final homeThemeManager = Provider.of<ThemeManager>(context);
    // unit = singletonWeightClass.getWeightUnitSymbol();

    String fullName = "${loggedInUser.firstName} ${loggedInUser.secondName}";
    return Material(
      child: Scaffold(
        drawer: MyDrawer(
          name: fullName,
          email: loggedInUser.email,
          phoneNum: loggedInUser.phoneNumber,
          // homePressed: homeButtonMethod(context),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            setState(() {
              weightController.clear();
            });
            actionButtonMethod();
          },
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: "Weight Tracker"
              .text
              .textStyle(
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
              .make(),
          actions: [
            Switch.adaptive(
              value: homeThemeManager.themeMode == ThemeMode.dark,
              onChanged: (value) {
                final provider =
                    Provider.of<ThemeManager>(context, listen: false);
                provider.toggleTheme(value);
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              // //GETTING DATA FROM SERVER (SECOND METHOD)
              // StreamBuilder<QuerySnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection("users")
              //       .doc(user!.uid)
              //       .collection("weights")
              //       .snapshots(),
              //   builder: (context, AsyncSnapshot snapshot) {
              //     if (!snapshot.hasData) {
              //       return const Text('Loading data.. Please Wait');
              //     }
              //     return GridView.builder(
              //       gridDelegate:
              //           const SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2,
              //         crossAxisSpacing: 10,
              //         mainAxisSpacing: 10,
              //       ),
              //       itemCount: snapshot.data.docs.length,
              //       itemBuilder: (context, index) {
              //         final item = snapshot.data.docs[index];
              //         return Card(
              //           color: Vx.gray200,
              //           child: Container(
              //             child: Column(
              //               children: [
              //                 "${item.id}"
              //                     .substring(0, 10)
              //                     .text
              //                     .bold
              //                     .textStyle(
              //                       const TextStyle(
              //                         fontSize: 16,
              //                         letterSpacing: 2,
              //                       ),
              //                     )
              //                     .make(),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.symmetric(vertical: 8),
              //                   child: Row(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       const Icon(
              //                         CupertinoIcons.clock_fill,
              //                         color: Colors.black,
              //                       ),
              //                       "${item.id}"
              //                           .substring(10, 19)
              //                           .text
              //                           .center
              //                           .make(),
              //                     ],
              //                   ),
              //                 ),
              //                 Expanded(
              //                   child: Container(
              //                     color: Colors.red,
              //                     child: "${item['weight']} ${unit}"
              //                         .text
              //                         .center
              //                         .textStyle(
              //                           const TextStyle(
              //                             fontSize: 20,
              //                             color: Colors.black,
              //                           ),
              //                         )
              //                         .make()
              //                         .expand(),
              //                   ).centered(),
              //                 ),
              //               ],
              //             ),
              //           ).py16(),
              //         );
              //       },
              //     ).expand();
              //   },
              // ),

              //ANOTHER STREAM BUILDER
              isLoading
                  ? Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => shimmerEffect(),
                        separatorBuilder: (context, index) => 10.heightBox,
                        itemCount: 6,
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(user!.uid)
                          .collection("weights")
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          //adding data to this list(dayAndWeightData)

                          return Expanded(
                            child: ListView.separated(
                              physics: const ScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              itemBuilder: (context, index) => shimmerEffect(),
                              separatorBuilder: (context, index) =>
                                  10.heightBox,
                              itemCount: 6,
                            ),
                          );
                        }

                        return Expanded(
                          child: ListView.builder(
                            physics: const ScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              final item = snapshot.data.docs[index];
                              var day = item.id.substring(8, 10) +
                                  "-" +
                                  item.id.substring(5, 7) +
                                  "-" +
                                  item.id.substring(0, 4);
                              var removeZero;
                              removeZero = removeDotZeroFunction(
                                  item['weight'].toString());
                              return Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.3,
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        setState(() {
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(user!.uid)
                                              .collection("weights")
                                              .doc(item.id)
                                              .delete();
                                        });
                                      },
                                      backgroundColor: Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  height: 80,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    // color: Colors.green,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: Row(
                                    children: [
                                      //
                                      //FIRST CIRCLE
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius:
                                              BorderRadius.circular(300),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Obx(
                                              () => Text(
                                                "${(double.parse(removeZero) / settingsPageController.currentWeightMultiplier.value).toStringAsFixed(2)} ${settingsPageController.currentWeightSymbol.value}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //
                                      //DETAILS
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    CupertinoIcons.calendar,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "${item['date']}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      CupertinoIcons.clock_fill,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                        "${item.id.substring(10, 19)}"),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  index == 0
                                                      ? const Icon(
                                                          CupertinoIcons.equal,
                                                          color:
                                                              Colors.deepPurple,
                                                          size: 18,
                                                        )
                                                      : (snapshot.data.docs[index]
                                                                  ['weight']) >
                                                              (snapshot.data
                                                                          .docs[
                                                                      index - 1]
                                                                  ['weight'])
                                                          ? const Icon(
                                                              CupertinoIcons
                                                                  .arrow_up,
                                                              color:
                                                                  Colors.green,
                                                              size: 18,
                                                            )
                                                          : (snapshot.data.docs[
                                                                          index][
                                                                      'weight']) ==
                                                                  (snapshot.data
                                                                          .docs[index - 1]
                                                                      ['weight'])
                                                              ? const Icon(
                                                                  CupertinoIcons
                                                                      .equal,
                                                                  color: Colors
                                                                      .deepPurple,
                                                                  size: 18,
                                                                )
                                                              : const Icon(
                                                                  CupertinoIcons
                                                                      .arrow_down,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 18,
                                                                ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  index == 0
                                                      ? Text("0.000")
                                                      : Text(
                                                          "${(snapshot.data.docs[index]['weight'] - snapshot.data.docs[index - 1]['weight']).abs().toStringAsFixed(3).toString()}"),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //
                                      //DAY
                                      Container(
                                        height: 80,
                                        width: 80,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _colorScheme.primaryVariant,
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${item['day'].substring(0, 3)}"
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  actionButtonMethod() {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          final _colorScheme2 = Theme.of(context).colorScheme;

          return Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 100) * 72,
                    child: Column(
                      children: [
                        //
                        //add weight row or form field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //add weight form field
                            SizedBox(
                              width:
                                  ((MediaQuery.of(context).size.width / 100) *
                                          72) -
                                      60,
                              child: TextFormField(
                                focusNode: mynode,
                                cursorColor: Colors.deepPurple,
                                // style: const TextStyle(
                                //   color: Colors.deepPurple,
                                // ),
                                // autofocus: true,
                                controller: weightController,
                                onChanged: (value) {
                                  // if (value.runtimeType == "String") {
                                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  //       content: "String is not allowed".text.make()));
                                  //   weightValue = '';
                                  // }
                                  weightValue = weightController.text;
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.]'))
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: "Enter Weight",
                                  labelText: "WEIGHT",
                                  labelStyle: TextStyle(
                                    color: mynode.hasFocus
                                        ? Colors.deepPurple
                                        : const Color(0xFF909090),
                                  ),
                                ),
                              ),
                            ),
                            //show weight unit
                            //in which weight to be added
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              width: 50,
                              height: 50,
                              child: Center(
                                child: Text(settingsPageController
                                    .currentWeightSymbol.value),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //ADD WEIGHT BUTTON
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            if (weightController.text.indexOf('.') !=
                                weightController.text.lastIndexOf('.')) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: "String is not allowed".text.make(),
                                ),
                              );
                              // Fluttertoast.showToast(
                              //     msg: "String is not allowed",
                              //     toastLength: Toast.LENGTH_LONG,
                              //     backgroundColor: Colors.red);
                              weightController.clear();
                              weightValue = weightController.text;
                            } else if (weightController.text.indexOf('.') ==
                                weightController.text.lastIndexOf('.')) {
                              homePageController.addWeight(double.parse(
                                  double.parse(weightValue)
                                      .toStringAsFixed(3)));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: "Your weight is added.".text.make(),
                                ),
                              );
                              setState(() {
                                weightController.clear();
                              });
                              Navigator.pop(context);
                            }
                            // try {
                            //   double.parse(weightController.text);
                            // } catch (e) {
                            //   print("iweorkfasdfasdf");
                            //   Navigator.pop(context);
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //           content:
                            //               "String is not allowed".text.make()));
                            //   Fluttertoast.showToast(
                            //       msg: "String is not allowed",
                            //       toastLength: Toast.LENGTH_LONG,
                            //       backgroundColor: Colors.red);
                            //   weightController.clear();
                            //   weightValue = weightController.text;
                            // }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 55,
                            child: Center(
                              child: Text(
                                "Add Weight in (${settingsPageController.currentWeightValue.value})",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              border: Border.all(
                                width: 1,
                                color: Colors.deepPurple,
                              ),
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CANCEL BUTTON MODAL
                  Material(
                    color: _colorScheme2.primaryVariant,
                    borderRadius: BorderRadius.circular(13),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(13),
                      splashColor: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 55,
                        width: (MediaQuery.of(context).size.width / 100) * 72,
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // getDataFromServer() async {
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   final _auth = FirebaseAuth.instance.currentUser;
  //   firebaseFirestore
  //       .collection("users")
  //       .doc(_auth!.uid)
  //       .collection("weights")
  //       .get()
  //       .then((value) =>
  //           WeightModel.sampleList = WeightModel.fromMap(value.data()));
  // }

  // homeButtonMethod(BuildContext context) {
  //   Navigator.pop(context);
  //   setState(() {});
  // }

  Widget shimmerEffect() {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //EFFECT FIRST CIRCLE
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(300),
            ),
          ),

          //EFFECT DETAILS
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 18,
                width: 160,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 18,
                width: 160,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 18,
                width: 160,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ).py12(),

          //EFFECT SECOND CIRCLE
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(300),
            ),
          ),
        ],
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  String removeDotZeroFunction(String removeZeroParameter) {
    if (removeZeroParameter.length > 1) {
      if ((removeZeroParameter.substring(removeZeroParameter.length - 2))
          .contains(".0")) {
        removeZeroParameter =
            removeZeroParameter.substring(0, removeZeroParameter.length - 2);
      } else {
        removeZeroParameter = removeZeroParameter;
      }
    }
    return removeZeroParameter;
  }
}

class HomePageController extends GetxController {
  // final homePageController = Get.put(HomePageController());
  final SettingsPageController settingsPageController =
      Get.put(SettingsPageController());

  addWeight(double someValue) {
    String value = DateTime.now().toString();
    String thisDate = value.substring(8, 10) +
        "-" +
        value.substring(5, 7) +
        "-" +
        value.substring(0, 4);
    WeightModel testWeight = WeightModel();
    testWeight.weight = double.parse(
        (someValue * settingsPageController.currentWeightMultiplier.value)
            .toStringAsFixed(2));
    print(DateFormat('EEEE').format(DateTime.now()));
    testWeight.day = DateFormat('EEEE').format(DateTime.now()).toString();
    testWeight.date = thisDate;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance.currentUser;
    firebaseFirestore
        .collection("users")
        .doc(_auth!.uid)
        .collection("weights")
        .doc(value)
        .set(testWeight.weightToMap());
  }
}
