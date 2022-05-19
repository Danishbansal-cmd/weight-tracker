import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:try1_something/models/user_model.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool whichLanguage = true;
  bool addNumber = false;

  final user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUsers = UserModel();

  //
  //initializing controller
  final settingsPageController = Get.put(SettingsPageController());

  //BASIC UNIT IS KG
    final Map MassList = {
      "Tonne": ["Tonne", "t", 1000000.0],
      "Kilogram": ["Kilogram", "kg", 1000.0],
      "Gram": ["Gram", "g", 1.0],
      "Milligram": ["Milligram", "mg", 0.001],
      "Microgram": ["Microgram", "µg", 0.000001],
      "Quintal": ["Quintal", "q", 100000.0],
      "Pound": ["Pound", "lb", 453.59237],
      "Ounce": ["Ounce", "oz", 28.3495231],
      "Carat": ["Carat", "ct", 0.2],
      "Grain": ["Grain", "gr", 0.06479891],
      "Stone": ["Stone", "st", 6350.29317],
      "Dram": ["Dram", "dr", 1.7718452],
      "Dan": ["Dan", "dan", 50000.0],
      "Jin": ["Jin", "jin", 500],
      "Qian": ["Qian", "qian", 5.0],
    };

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUsers = UserModel.fromMap(value.data());
      setState(() {});
    });

    print("settings");
    print("settings");
    print("settings");
    print("settings");
    print(user!.uid);
    print(loggedInUsers);
    print(loggedInUsers.email);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: Text(
            "Settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )),
          body: Container(
            color: Colors.grey.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("E-mail address"),
                            Text("${loggedInUsers.email}"),
                          ],
                        ),
                      ),
                      fucntionDivider(),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: addNumber ? 0 : 15,
                              ),
                              child: Text("Phone number"),
                            ),
                            Row(
                              children: [
                                addNumber
                                    ? Container(
                                        height: 47,
                                        width: 100,
                                        child: Flexible(
                                          fit: FlexFit.loose,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 0),
                                              hintText: "Enter Number",
                                              border: InputBorder.none,
                                            ),
                                            // validator: (){},
                                            // onChanged: (value) {
                                            //   setState(() {
                                            //     phoneNum = int.parse(value);
                                            //   });
                                            // },
                                          ),
                                        ),
                                      )
                                    : Text(''),
                                SizedBox(
                                  height: 20,
                                ),
                                loggedInUsers.phoneNumber?.length == 0
                                    ? InkWell(
                                        onTap: () {
                                          addNumber = !addNumber;
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          child: Text("ADD"),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      )
                                    : Text(''),
                              ],
                            ),
                          ],
                        ),
                      ),
                      fucntionDivider(),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Password"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // LANGUAGE SETTINGS
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20)
                          .copyWith(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Language settings",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 3)
                                ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade200,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            toggleButton(context, "English"),
                            toggleButton(context, "German"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //UNIT SETTINGS
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weigh your weight in",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                      // isDismissible: false,
                                      // enableDrag: false,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          chooseWeightUnit(context),
                                    );
                            },
                            child: Text(MassList[settingsPageController.currentWeightValue.value][1]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fucntionDivider() {
    return Divider(
      color: Colors.grey.shade300, //color of divider
      height: 1, //height spacing of divider
      thickness: 1, //thickness of divier line
      // indent: 25, //spacing at the start of divider
      // endIndent: 25, //spacing at the end of divider
    );
  }

  Widget toggleButton(BuildContext context, String value) {
    return InkWell(
      onTap: () {
        whichLanguage = !whichLanguage;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: (value != "German")
              ? (whichLanguage ? Colors.white : Colors.grey.shade200)
              : (whichLanguage ? Colors.grey.shade200 : Colors.white),
        ),
        width: (MediaQuery.of(context).size.width - 46) / 2,
        child: Text(
          value,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  changeUnitMethod() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: Container(
            child: ListView.builder(itemBuilder: (BuildContext context, index) {
              return Text('gy');
            }),
          ),
        );
      },
    );
  }

  homeButtonMethod(BuildContext context) {
    Navigator.pop(context);
    setState(() {});
  }

  Widget chooseWeightUnit(context) {
    final _colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.55,
          maxChildSize: 0.55,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: _colorScheme.background,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20),),
            ),
            child: Column(
              children: [
                //
                // MODAL HEADING
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  height: 60,
                  child: "Select Unit"
                      .text
                      .textStyle(
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                      .make()
                      .centered(),
                ),
                //
                // UNITS LIST
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      // controller: controller,
                      physics: const ScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(onTap: (){
                          settingsPageController.currentWeightValue.value = MassList[MassList.keys.toList()[index]][0];
                        },child: Container(padding: const EdgeInsets.only(left: 30, top: 25, bottom: 25),child: Text(MassList[MassList.keys.toList()[index]][0]),),);
                      },
                      itemCount: MassList.length,
                    ),
                  ),
                ),
                //
                // // CANCEL MODAL BUTTON
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: "Cancel".text.center.bold.make().py(13),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      border: Border.all(
                        width: 1,
                        color: Colors.deepPurple,
                      ),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ).pSymmetric(v: 20, h: 50),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



}


class SettingsPageController extends GetxController{
  RxString currentWeightValue = 'Kilogram'.obs;

}
