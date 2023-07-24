import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double currentHeight = 0.0;
  double currentWeight = 0.0;
  bool weightInKg = true;
  String weightUnit = "kg";
  bool heightInCm = true;
  String heightUnit = "cm";
  double maxHeight = 250;
  double maxWeight = 200;
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  @override
  void initState() {
    super.initState();
    weightController.addListener(() {
      setState(() {
        if (currentWeight >= maxWeight) {
          currentWeight = 0.0;
          weightController.text = "";
        } else {
          currentWeight = double.parse(weightController.text.toString());
        }
      });
    });
    heightController.addListener(() {
      setState(() {
        if (currentHeight >= maxHeight) {
          currentHeight = 0.0;
          heightController.text = "";
        } else {
          currentHeight = double.parse(heightController.text.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return portraitDesign(context);
            } else {
              return landscapeDesign(context);
            }
          },
        ));
  }

  Column portraitDesign(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Divider(
          height: 50,
        ),
        heightBox(),
        weightBox(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
              onPressed: () {
                if ((weightController.text.isNotEmpty &&
                        heightController.text.isNotEmpty) &&
                    (currentHeight != 0 && currentWeight != 0)) {
                  showBMI();
                } else {
                  SnackBar snackBar = const SnackBar(
                    content: Text("Invalid Data, Please enter some data"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              label: const Text("Calculate BMI")),
        )
      ],
    );
  }

  Widget landscapeDesign(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Divider(
            height: 50,
          ),
          Row(
            children: [
              heightBox(),
              weightBox(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
                onPressed: () {
                  if ((weightController.text.isNotEmpty &&
                          heightController.text.isNotEmpty) &&
                      (currentHeight != 0 && currentWeight != 0)) {
                    showBMI();
                  } else {
                    SnackBar snackBar = const SnackBar(
                      content: Text("Invalid Data, Please enter some data"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                label: const Text("Calculate BMI")),
          )
        ],
      ),
    );
  }

  Flexible genderBox(String gender, Color fillColor, Color outlineColor) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          color: fillColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: outlineColor, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          elevation: 10,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blueGrey,
            onTap: () {},
            child: SizedBox(
              height: 50,
              child: Center(
                child: Text(gender),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget heightBox() {
    return Flexible(
        child: Card(
      elevation: 10,
      margin: const EdgeInsets.all(10),
      color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Slider(
            max: maxHeight,
            value: currentHeight,
            label: currentHeight.toString(),
            onChanged: (value) {
              setState(() {
                heightController.text = value.toStringAsFixed(2);
                currentHeight = value;
              });
            },
          ),
          SizedBox(
            width: 80,
            child: TextField(
              inputFormatters: [NumericRangeFormatter(min: 0, max: maxHeight)],
              decoration: const InputDecoration(
                  filled: true, fillColor: Color.fromARGB(98, 255, 193, 7)),
              textAlign: TextAlign.center,
              controller: heightController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: false),
            ),
          ),
          const Text(
            "Height",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Switch(
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.teal,
                    inactiveThumbColor: Colors.white,
                    value: heightInCm,
                    onChanged: (value) {
                      toggleHeight();
                    }),
                Text(heightUnit),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget weightBox() {
    return Flexible(
        child: Card(
      margin: const EdgeInsets.all(10),
      elevation: 10,
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Slider(
            max: maxWeight,
            value: currentWeight,
            label: currentWeight.toString(),
            onChanged: (value) {
              setState(() {
                weightController.text = value.toStringAsFixed(2);
                currentWeight = value;
              });
            },
          ),
          SizedBox(
            width: 80,
            child: TextField(
              inputFormatters: [NumericRangeFormatter(min: 0, max: maxWeight)],
              decoration: const InputDecoration(
                  filled: true, fillColor: Color.fromARGB(80, 25, 118, 210)),
              textAlign: TextAlign.center,
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: false),
            ),
          ),
          const Text(
            "Weight",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Switch(
                    activeTrackColor: Colors.purple,
                    inactiveTrackColor: Colors.purpleAccent,
                    inactiveThumbColor: Colors.white,
                    value: weightInKg,
                    onChanged: (value) {
                      toggleWeight();
                    }),
                Text(weightUnit),
              ],
            ),
          )
        ],
      ),
    ));
  }

  void toggleWeight() {
    if (weightInKg == true) {
      setState(() {
        weightInKg = false;
        currentWeight = currentWeight * 2.205;
        weightUnit = "lbs";
        maxWeight = 400;
        weightController.text = currentWeight.toStringAsFixed(2);
      });
    } else {
      setState(() {
        weightInKg = true;
        currentWeight = currentWeight / 2.205;
        weightUnit = "kg";
        maxWeight = 200;
        weightController.text = currentWeight.toStringAsFixed(2);
      });
    }
  }

  void toggleHeight() {
    if (heightInCm == true) {
      setState(() {
        heightInCm = false;
        currentHeight = currentHeight / 30.48;
        heightUnit = "ft";
        maxHeight = 10;
        heightController.text = currentHeight.toStringAsFixed(2);
      });
    } else {
      setState(() {
        heightInCm = true;
        currentHeight = currentHeight * 30.48;
        heightUnit = "cm";
        maxHeight = 300;
        heightController.text = currentHeight.toStringAsFixed(2);
      });
    }
  }

  double calcBMI() {
    double weight = currentWeight;
    double height = currentHeight;
    if (heightInCm == false) {
      height = height * 30.48;
    }
    if (weightInKg == false) {
      weight = weight / 2.205;
    }
    return weight * 10000 / (height * height);
  }

  void showBMI() {
    double bmi = calcBMI();
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          body: Container(
              color: Colors.grey.shade400,
              child: OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return portraitResult(bmi, context);
                  } else {
                    return landScapeResult(bmi, context);
                  }
                },
              )),
        );
      },
    );
  }

  Column portraitResult(double bmi, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SfRadialGauge(
            enableLoadingAnimation: true,
            animationDuration: 3500,
            axes: <RadialAxis>[
              RadialAxis(
                annotations: [
                  GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.5,
                      widget: Text(
                        bmi.toStringAsFixed(2),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ))
                ],
                minimum: 0,
                maximum: 50,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 18.5,
                      color: Colors.blue,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 18.5,
                      endValue: 25,
                      color: Colors.green,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 25,
                      endValue: 30,
                      color: Colors.yellow,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 30,
                      endValue: 35,
                      color: Colors.orange,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 35,
                      endValue: 50,
                      color: Colors.deepOrange,
                      startWidth: 10,
                      endWidth: 10)
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: bmi,
                  )
                ],
              )
            ]),
        results(bmi),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Dismiss"),
        ),
      ],
    );
  }

  Row landScapeResult(double bmi, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SfRadialGauge(
            enableLoadingAnimation: true,
            animationDuration: 3500,
            axes: <RadialAxis>[
              RadialAxis(
                annotations: [
                  GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.5,
                      widget: Text(
                        bmi.toStringAsFixed(2),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ))
                ],
                minimum: 0,
                maximum: 50,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 18.5,
                      color: Colors.blue,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 18.5,
                      endValue: 25,
                      color: Colors.green,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 25,
                      endValue: 30,
                      color: Colors.yellow,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 30,
                      endValue: 35,
                      color: Colors.orange,
                      startWidth: 10,
                      endWidth: 10),
                  GaugeRange(
                      startValue: 35,
                      endValue: 50,
                      color: Colors.deepOrange,
                      startWidth: 10,
                      endWidth: 10)
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: bmi,
                  )
                ],
              )
            ]),
        results(bmi),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Dismiss"),
        ),
      ],
    );
  }

  Widget results(double bmi) {
    String condition = "";
    Color condtionColor = Colors.black;
    switch (bmi) {
      case < 18.5:
        condition = "Underweight";
        condtionColor = Colors.blue;
        break;
      case >= 18.5 && < 25:
        condition = "Normal";
        condtionColor = Colors.greenAccent;
        break;
      case >= 25 && < 30:
        condition = "Overweight";
        condtionColor = Colors.yellow;
        break;
      case >= 30 && < 35:
        condition = "Obese";
        condtionColor = Colors.orange;
        break;
      case >= 35:
        condition = "Extreme Obese";
        condtionColor = Colors.red;
        break;
    }
    return SizedBox(
      height: 80,
      child: Card(
        color: condtionColor,
        elevation: 10,
        child: Center(
            child: Text(
          condition,
          style: const TextStyle(fontSize: 40),
        )),
      ),
    );
  }
}

class NumericRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final newValueNumber = double.tryParse(newValue.text);

    if (newValueNumber == null) {
      return oldValue;
    }

    if (newValueNumber < min) {
      return newValue.copyWith(text: min.toString());
    } else if (newValueNumber > max) {
      return newValue.copyWith(text: max.toString());
    } else {
      return newValue;
    }
  }
}
