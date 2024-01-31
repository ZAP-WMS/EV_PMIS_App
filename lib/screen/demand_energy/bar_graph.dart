import 'package:ev_pmis_app/provider/All_Depo_Select_Provider.dart';
import 'package:ev_pmis_app/provider/demandEnergyProvider.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarGraphScreen extends StatefulWidget {
  final List<dynamic> timeIntervalList;
  final List<dynamic> monthList;

  const BarGraphScreen({
    super.key,
    required this.timeIntervalList,
    required this.monthList,
  });

  @override
  State<BarGraphScreen> createState() => _BarGraphScreenState();
}

class _BarGraphScreenState extends State<BarGraphScreen> {
  bool isFirstTime = true;

  int _selectedIndex = 0;

  List<bool> choiceChipBoolList = [true, false, false, false];

  final Gradient _barRodGradient = const LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color.fromARGB(255, 16, 81, 231),
      Color.fromARGB(255, 190, 207, 252)
    ],
  );

  List<String> choiceChipLabels = ['Day', 'Monthly', 'Quaterly', 'Yearly'];
  List<String> quaterlyMonths = [
    'Jan - Mar',
    'Apr - Jun',
    'Jul - Sep',
    'Oct - Dec'
  ];
  List<String> yearlyMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  final double candleWidth = 20;

  @override
  void initState() {
    widget.timeIntervalList.add('Candle1');
    widget.timeIntervalList.add('Candle2');
    widget.timeIntervalList.add('Candle3');
    widget.timeIntervalList.add('Candle4');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    final allDepoProvider =
        Provider.of<AllDepoSelectProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        allDepoProvider.setCheckedBool(false);
        return true;
      },
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 234, 243, 250),
                  borderRadius: BorderRadius.circular(5)),
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text(
                'Energy Consumed (in kW)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Consumer<DemandEnergyProvider>(
              builder: (context, providerValue, child) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          height: 30,
                          width: 320,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: choiceChipLabels.length,
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 2),
                                  // height: 30,
                                  child: ChoiceChip(
                                    label: Text(
                                      choiceChipLabels[index],
                                      style:
                                          TextStyle(color: white, fontSize: 12),
                                    ),
                                    selected: choiceChipBoolList[index],
                                    selectedColor: Colors.blue,
                                    backgroundColor: blue,
                                    onSelected: provider.isLoadingBarCandle
                                        ? (_) {}
                                        : (value) {
                                            if (provider
                                                    .selectedDepo.isNotEmpty ||
                                                allDepoProvider.isChecked ==
                                                    true) {
                                              // isFirstTime = false;
                                              switch (index) {
                                                case 0:
                                                  _selectedIndex = 0;
                                                  provider.setLoadingBarCandle(
                                                      true);
                                                  break;
                                                case 1:
                                                  _selectedIndex = 1;
                                                  provider.setLoadingBarCandle(
                                                      true);
                                                  break;
                                                case 2:
                                                  _selectedIndex = 2;
                                                  provider.setLoadingBarCandle(
                                                      true);
                                                  break;
                                                case 3:
                                                  _selectedIndex = 3;
                                                  provider.setLoadingBarCandle(
                                                      true);
                                                  break;
                                                default:
                                                  _selectedIndex = 0;
                                              }
                                              choiceChipBoolList[index] = value;
                                              resetChoiceChip(index);
                                              providerValue.reloadWidget(true);
                                              providerValue.setSelectedIndex(
                                                  _selectedIndex,
                                                  allDepoProvider.isChecked);
                                            } else {
                                              showCustomAlert();
                                            }
                                          },
                                  ),
                                );
                              })),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            Consumer<DemandEnergyProvider>(
              builder: (context, value, child) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 5),
                    // color: blue,
                    height: height * 0.45,
                    width:
                        allDepoProvider.isChecked && provider.selectedIndex == 0
                            ? 1000
                            : width * 0.98,
                    child: BarChart(
                      swapAnimationCurve: Curves.easeInOut,
                      swapAnimationDuration: const Duration(
                        milliseconds: 1500,
                      ),
                      BarChartData(
                        alignment: BarChartAlignment.spaceEvenly,
                        // backgroundColor: const Color.fromARGB(
                        //   255,
                        //   236,
                        //   252,
                        //   255,
                        // ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipRoundedRadius: 5,
                            tooltipBgColor: Colors.transparent,
                            tooltipMargin: 5,
                          ),
                        ),
                        maxY: (provider.maxEnergyConsumed ?? 0.0) + 5000,
                        minY: 0,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 150,
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.only(left: 90),
                                  child: Transform.rotate(
                                    alignment: Alignment.center,
                                    angle: 30.2,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 130),
                                        child: Text(
                                          getTextForBarChart(
                                              _selectedIndex,
                                              allDepoProvider.isChecked,
                                              value.toInt()),
                                          // textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: false,
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          checkToShowHorizontalLine: (value) => value % 1 == 0,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          border: const Border(
                            left: BorderSide(),
                            bottom: BorderSide(),
                          ),
                        ),
                        barGroups: allDepoProvider.isChecked == false
                            ? provider.selectedIndex == 1
                                ? getMonthlyBarGroups()
                                : provider.selectedIndex == 2
                                    ? getQuaterlyBarData()
                                    : provider.selectedIndex == 3
                                        ? getYearlyBarData()
                                        : getBarGroups()
                            : provider.selectedIndex == 0
                                ? getAllDepoDailyBarGroupData()
                                : provider.selectedIndex == 1
                                    ? getAllDepoMonthlyBarGroupData(
                                        provider.maxEnergyConsumed ?? 0)
                                    : provider.selectedIndex == 2
                                        ? getAllDepoQuarterlyBarGroupData()
                                        : getAllDepoYearlyBarGroupData(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String getTextForBarChart(int currentIndex, bool isChecked, int value) {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    // isFirstTime = false;
    if (isChecked == false) {
      switch (currentIndex) {
        case 0:
          return widget.timeIntervalList[value.toInt()];
        case 1:
          return widget.monthList[value.toInt()];
        case 2:
          return quaterlyMonths[value.toInt()];
        case 3:
          return yearlyMonths[value.toInt()];
      }
    } else {
      switch (currentIndex) {
        case 0:
          return provider.depoList![value.toInt()];
        case 1:
          return widget.monthList[value.toInt()];

        case 2:
          return quaterlyMonths[value.toInt()];
        case 3:
          return yearlyMonths[value.toInt()];
      }
    }
    return '';
  }

  List<BarChartGroupData> getBarGroups() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    print('Fetching BarGroups - ${provider.dailyEnergyConsumed}');
    return List.generate(
      widget.timeIntervalList.length,
      (index) {
        return BarChartGroupData(
          // groupVertically: true,
          showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              // toY: 100,
              toY: provider.dailyEnergyConsumed?[index] ?? 0.0,
            ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getMonthlyBarGroups() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    final allDepoProvider =
        Provider.of<AllDepoSelectProvider>(context, listen: false);
    // print('Monthly BarChart Data Extracting - ${provider.maxEnergyConsumed}');
    return List.generate(
      1,
      (index) {
        return BarChartGroupData(
          showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: provider.maxEnergyConsumed ?? 0.0,
            ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getQuaterlyBarData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    // print('Quaterly BarChart Data Extracting');
    return List.generate(
      4,
      (index) {
        return BarChartGroupData(
          showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: provider.quaterlyEnergyConsumedList?[index] ?? 0.0,
            ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getYearlyBarData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);

    // print('Yearly BarChart Data Extracting');
    return List.generate(
      12,
      (index) {
        return BarChartGroupData(
          showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: provider.yearlyEnergyConsumedList?[index] ?? 0.0,
            ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getAllDepoDailyBarGroupData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    // print('Daily BarChart Data Extracting');
    return List.generate(
      provider.depoList?.length ?? 0,
      (index) {
        return BarChartGroupData(
          // groupVertically: true,
          showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: provider.allDepoDailyEnergyConsumedList?[index] ?? 0,
            ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getAllDepoMonthlyBarGroupData(
      double? energyConsumed) {
    return List.generate(
      1,
      (index) {
        return BarChartGroupData(
          // groupVertically: true,
          showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: energyConsumed ?? 0.0,
            ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getAllDepoQuarterlyBarGroupData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    // print('Daily BarChart Data Extracting');
    return List.generate(
      4,
      (index) {
        return BarChartGroupData(
          // groupVertically: true,
          showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: provider.allDepoQuaterlyEnergyConsumedList?[index] ?? 0.0,
            ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getAllDepoYearlyBarGroupData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);

    // print('Daily BarChart Data Extracting');
    return List.generate(
      12,
      (index) {
        return BarChartGroupData(
          // groupVertically: true,
          showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: provider.allDepoYearlyEnergyConsumedList?[index] ?? 0.0,
            ),
          ],
        );
      },
    ).toList();
  }

  void resetChoiceChip(index) {
    for (int i = 0; i < choiceChipBoolList.length; i++) {
      if (index != i) {
        choiceChipBoolList[i] = false;
      }
    }
  }

  Future<void> showCustomAlert() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: 300,
              height: 170,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Icon(
                      Icons.warning,
                      color: Color.fromARGB(255, 240, 222, 67),
                      size: 80,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'Please Select a Depot First',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 30,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(blue)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}