import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsPage extends StatefulWidget {
  AnalyticsPage({Key? key}) : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  //
  //initializing controller
  final analyticsPageController = Get.put(AnalyticsPageController());

  //variables
  User? user = FirebaseAuth.instance.currentUser;

  //init method
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("weights")
        .get()
        .then(
          (value) => value.docs.forEach((element) {
            analyticsPageController.dayAndWeightData.add(
              dayAndWeightDataModel(
                day: element.id.substring(8, 10),
                weight: element['weight'],
              ),
            );
            print('each data ${element['weight']}');
            print('each data id ${element.id.runtimeType}');
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analytics'),),
      body: Column(
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
                  visible: analyticsPageController.dayAndWeightData.isEmpty,
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
        ],
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
          maxY: 200,
          lineBarsData: [
            LineChartBarData(
              spots: List<FlSpot>.generate(
                analyticsPageController.dayAndWeightData.length,
                (index) => FlSpot(
                  double.parse(
                      analyticsPageController.dayAndWeightData[index].day!),
                  analyticsPageController.dayAndWeightData[index].weight!,
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
}

class dayAndWeightDataModel {
  String? day;
  double? weight;
  dayAndWeightDataModel({this.day, this.weight});
}

class AnalyticsPageController extends GetxController {
  List<dayAndWeightDataModel> dayAndWeightData = <dayAndWeightDataModel>[].obs;
}
