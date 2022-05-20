import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController weightController = TextEditingController();
  // late Stream<QuerySnapshot> snapshot;
  bool isLoading = true;
  bool isLoading2 = true;
  FocusNode mynode = new FocusNode();
  // List<dayAndWeightDataModel> dayAndWeightData = [];

  //
  //initializing controller
  final homePageController = Get.put(HomePageController());
  final SettingsPageController settingsPageController =
      Get.put(SettingsPageController());

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
    final _auth = FirebaseAuth.instance.currentUser;
    final CollectionReference firebaseFirestore = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("weights");
    firebaseFirestore.get().then(
          (value) => value.docs.forEach((element) {
            homePageController.dayAndWeightData.add(
              dayAndWeightDataModel(
                day: element.id.substring(8, 10),
                weight: element['weight'],
              ),
            );
            print('each data ${element['weight']}');
            print('each data id ${element.id.runtimeType}');
          }),
        );
    print('dayAndWeightData ${homePageController.dayAndWeightData}');

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
    setState(() {});
    final _colorScheme = Theme.of(context).colorScheme;
    final _textScheme = Theme.of(context).textTheme;
    final homeThemeManager = Provider.of<ThemeManager>(context);
    // unit = singletonWeightClass.getWeightUnitSymbol();

    String fullName = "${loggedInUser.firstName} ${loggedInUser.secondName}";
    return Material(
      child: SafeArea(
        child: Scaffold(
          drawer: MyDrawer(
            name: fullName,
            email: loggedInUser.email,
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
                //
                //Progress column
                Stack(
                  children: [
                    //
                    //main container to hold all
                    //chart data
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 7,
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ).copyWith(
                        top: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(17, 0, 0, 0),
                            blurRadius: 10.0,
                            spreadRadius: 6.0,
                            offset: Offset(0.0, 0.0),
                          ),
                        ],
                      ),
                      height: 220,
                      child: returnLineChartOfWeights(),
                    ),

                    //
                    //container to show
                    //circular progress bar on it
                    Obx(
                      () => Visibility(
                        visible: homePageController.dayAndWeightData.isEmpty,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ).copyWith(
                            top: 10,
                          ),
                          height: 220,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

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
                                itemBuilder: (context, index) =>
                                    shimmerEffect(),
                                separatorBuilder: (context, index) =>
                                    10.heightBox,
                                itemCount: 6,
                              ),
                            );
                          }

                          return ListView.builder(
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
                              if (item['weight'].toString().contains(".0")) {
                                removeZero = item['weight']
                                    .toString()
                                    .replaceAll(".0", "");
                              } else {
                                removeZero = item['weight'].toString();
                              }
                              return Dismissible(
                                key: UniqueKey(),
                                background: Container(
                                  color: Colors.red,
                                ),
                                onDismissed: (direction) {
                                  setState(() {
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(user!.uid)
                                        .collection("weights")
                                        .doc(item.id)
                                        .delete()
                                        .then((value) => print(
                                            "success\nsuccess\nsuccesnsuccess"));
                                  });
                                },
                                direction: DismissDirection.endToStart,
                                child: Container(
                                  height: 110,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: Row(
                                    children: [
                                      //
                                      //FIRST CIRCLE
                                      Container(
                                        height: 100,
                                        width: 100,
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
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //DETAILS
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 20),
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
                                                5.widthBox,
                                                "${item['date']}"
                                                    .text
                                                    .bold
                                                    .textStyle(
                                                      const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    )
                                                    .make(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  CupertinoIcons.clock_fill,
                                                  size: 18,
                                                ),
                                                5.widthBox,
                                                "${item.id}"
                                                    .substring(10, 19)
                                                    .text
                                                    .center
                                                    .make(),
                                              ],
                                            ).py8(),
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
                                                            (snapshot.data.docs[
                                                                    index - 1]
                                                                ['weight'])
                                                        ? const Icon(
                                                            CupertinoIcons
                                                                .arrow_up,
                                                            color: Colors.green,
                                                            size: 18,
                                                          )
                                                        : (snapshot.data.docs[index]
                                                                    [
                                                                    'weight']) ==
                                                                (snapshot.data
                                                                            .docs[
                                                                        index -
                                                                            1]
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
                                                                color:
                                                                    Colors.red,
                                                                size: 18,
                                                              ),
                                                5.widthBox,
                                                index == 0
                                                    ? "0.000".text.make()
                                                    : "${(snapshot.data.docs[index]['weight'] - snapshot.data.docs[index - 1]['weight']).abs().toStringAsFixed(3).toString()}"
                                                        .text
                                                        .make(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ).expand(),

                                      //DAY
                                      Container(
                                        height: 100,
                                        width: 100,
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
                                            "${item['day']}"
                                                .substring(0, 3)
                                                .text
                                                .uppercase
                                                .textStyle(
                                                  const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                )
                                                .make(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ).pOnly(top: 2, bottom: 10),
                              );
                            },
                          ).expand();
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  actionButtonMethod() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          final _colorScheme2 = Theme.of(context).colorScheme;

          return Material(
            // color: Colors.red,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: Colors.yellow),
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
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'))
                            ],
                            decoration: InputDecoration(
                              hintText: "Enter Weight",
                              labelText: "WEIGHT",
                              labelStyle: TextStyle(
                                color: mynode.hasFocus
                                    ? Colors.deepPurple
                                    : const Color(0xFF909090),
                              ),
                              // enabledBorder: UnderlineInputBorder(
                              //     borderSide:
                              //         BorderSide(color: Colors.deepPurple)),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                  width: 2,
                                ),
                              ),
                              // focusColor: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      20.heightBox,
                      //ADD WEIGHT BUTTON
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (weightController.text.indexOf('.') !=
                                weightController.text.lastIndexOf('.')) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: "String is not allowed".text.make(),
                                ),
                              );
                              Fluttertoast.showToast(
                                  msg: "String is not allowed",
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.red);
                              weightController.clear();
                              weightValue = weightController.text;
                            } else if (weightController.text.indexOf('.') ==
                                weightController.text.lastIndexOf('.')) {
                              addWeight(double.parse(double.parse(weightValue)
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

                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: "Add Weight"
                              .text
                              .center
                              .bold
                              .color(Colors.white)
                              .make()
                              .py(13),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            border: Border.all(
                              width: 1,
                              color: Colors.deepPurple,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ).w64(context),

                  // CANCEL BUTTON MODAL
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: "Cancel".text.center.bold.make().py(13),
                      decoration: BoxDecoration(
                        color: _colorScheme2.primaryVariant,
                        border: Border.all(
                          width: 1,
                          color: _colorScheme2.primaryVariant,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ).w64(context),
                  ),
                ],
              ),
            ),
          );
        });
  }

  addWeight(double someValue) {
    String value = DateTime.now().toString();
    String thisDate = value.substring(8, 10) +
        "-" +
        value.substring(5, 7) +
        "-" +
        value.substring(0, 4);
    WeightModel testWeight = WeightModel();
    testWeight.weight = someValue;
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

  //return data of weights
  Widget returnLineChartOfWeights() {
    //testing data for charts
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];
    return Obx(
      () => LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 10,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 28,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: const Color(0xff37434d),
              width: 1,
            ),
          ),
          minX: 0,
          minY: 0,
          maxX: 31,
          maxY: 200 ,
          lineBarsData: [
            LineChartBarData(
              spots: List<FlSpot>.generate(
                homePageController.dayAndWeightData.length,
                (index) => FlSpot(
                  double.parse(homePageController.dayAndWeightData[index].day!),
                  homePageController.dayAndWeightData[index].weight!,
                ),
              ),
              // const [
              //   FlSpot(0, 3),
              //   FlSpot(2.6, 2),
              //   FlSpot(4.9, 5),
              //   FlSpot(6.8, 3.1),
              //   FlSpot(8, 4),
              //   FlSpot(9.5, 3),
              //   FlSpot(11, 4),
              // ],
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('MAR', style: style);
        break;
      case 3:
        text = const Text('3', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 9:
        text = const Text('9', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 15:
        text = const Text('15', style: style);
        break;
      case 18:
        text = const Text('18', style: style);
        break;
      case 21:
        text = const Text('21', style: style);
        break;
      case 24:
        text = const Text('24', style: style);
        break;
      case 27:
        text = const Text('27', style: style);
        break;
      case 30:
        text = const Text('30', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 8.0));
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'KG';
        break;
      case 30:
        text = '30';
        break;
      case 60:
        text = '60';
        break;
      case 90:
        text = '90';
        break;
      case 120:
        text = '120';
        break;
      case 150:
        text = '150';
        break;
      case 180:
        text = '180';
        break;
      case 210:
        text = '210';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  // LineChartData mainData() {

  //   return
  // }
}

class dayAndWeightDataModel {
  String? day;
  double? weight;
  dayAndWeightDataModel({this.day, this.weight});
}

class HomePageController extends GetxController {
  List<dayAndWeightDataModel> dayAndWeightData = <dayAndWeightDataModel>[].obs;
}
