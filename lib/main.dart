import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _calculated = false;
  String? calcSystem = '';
  double _bmi = 0;
  String heightText = "Height";
  String weightText = "Weight";
  int _bmiToPercent = 0;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  Color progressColor = Colors.blue;
  final TextEditingController _age = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _weight = TextEditingController();

  @override
  void initState() {
    super.initState();
    _height.addListener(calcBmi);
    _weight.addListener(calcBmi);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (focusNode1.hasFocus) {
          focusNode1.unfocus();
        }
        if (focusNode2.hasFocus) {
          focusNode2.unfocus();
        }
        if (focusNode3.hasFocus) {
          focusNode3.unfocus();
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("BMI Calculator", style: TextStyle(fontSize: 30)),
          elevation: 5,
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      focusNode: focusNode3,
                      keyboardType: TextInputType.number,
                      controller: _age,
                      decoration: const InputDecoration(
                          labelText: "Age",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10))),
                    ),
                    const Divider(
                      height: 15,
                      thickness: 2,
                    ),
                    TextField(
                      focusNode: focusNode1,
                      keyboardType: TextInputType.number,
                      controller: _height,
                      decoration: InputDecoration(
                          labelText: heightText,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 10))),
                    ),
                    const Divider(
                      height: 15,
                      thickness: 2,
                    ),
                    TextField(
                      focusNode: focusNode2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: weightText,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 10))),
                      controller: _weight,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: const Text("Metric"),
                      leading: Radio(
                        value: "Metric",
                        groupValue: calcSystem,
                        onChanged: (value) {
                          setState(() {
                            calcSystem = value;
                            weightText = "Weight in kg";
                            heightText = "Height in meters";
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Imperial"),
                      leading: Radio(
                        value: "Imperial",
                        groupValue: calcSystem,
                        onChanged: (value) {
                          setState(() {
                            calcSystem = value;
                            weightText = "Weight in pounds";
                            heightText = "Height in inches";
                          });
                        },
                      ),
                    ),
                    Visibility(
                        visible: _calculated,
                        child: Column(
                          children: [
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: CircularStepProgressIndicator(
                                totalSteps: 100,
                                currentStep: _bmiToPercent,
                                selectedColor: progressColor,
                                stepSize: 8,
                                unselectedColor: Colors.grey,
                                padding: 0,
                                width: 120,
                                height: 120,
                                selectedStepSize: 10,
                                child: Center(
                                    child: Text(
                                  _bmi.toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 20),
                                )),
                              ),
                            ),
                            getResult(_bmi)
                          ],
                        )),
                  ]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              progressManager(context);
            },
            label: const Text("Calculate")),
      ),
    );
  }

  void progressManager(BuildContext context) {
    if (_height.text.isEmpty ||
        _weight.text.isEmpty ||
        double.parse(_weight.text) <= 0 ||
        double.parse(_height.text) <= 0) {
      setState(() {
        _calculated = false;
      });
      SnackBar snackBar = const SnackBar(
        content: Text("Invalid Data\t,\ttry again"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (calcSystem == '') {
      setState(() {
        _calculated = false;
      });
      SnackBar snackBar = const SnackBar(
        content: Text("Please Select a Calculation System"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      calcBmi();
    }
  }

  void calcBmi() {
    if (_height.text.isEmpty ||
        _weight.text.isEmpty ||
        double.parse(_weight.text) <= 0 ||
        double.parse(_height.text) <= 0) {
      setState(() {
        _calculated = false;
      });
    }
    if (calcSystem == "Imperial") {
      setState(() {
        _bmi = (703 *
            double.parse(_weight.text) /
            (double.parse(_height.text) * double.parse(_height.text)));
        progressColor = setProgressColor(_bmi);
        _bmiToPercent = getPercentageBmi(_bmi);
        _calculated = true;
      });
    } else if (calcSystem == "Metric") {
      setState(() {
        _bmi = (double.parse(_weight.text) /
            (double.parse(_height.text) * double.parse(_height.text)));
        progressColor = setProgressColor(_bmi);
        _bmiToPercent = getPercentageBmi(_bmi);
        _calculated = true;
      });
    }
  }
}

int getPercentageBmi(double bmi) {
  if (bmi >= 35) {
    return 99;
  } else {
    return (bmi / 35 * 100).round();
  }
}

Color setProgressColor(double bmi) {
  switch (bmi) {
    case < 18.5:
      return Colors.blue;
    case >= 18.5 && < 24.9:
      return Colors.green;
    case > 25 && < 29.9:
      return Colors.yellowAccent;
    case > 30 && < 34.9:
      return Colors.orange;
    case > 35:
      return Colors.red;

    default:
      return Colors.grey;
  }
}

Text getResult(double bmi) {
  switch (bmi) {
    case < 18.5:
      return const Text(
        "Underweight",
        style: TextStyle(color: Colors.blue, fontSize: 15),
      );
    case >= 18.5 && < 24.9:
      return const Text(
        "Normal",
        style: TextStyle(color: Colors.green, fontSize: 20),
      );
    case > 25 && < 29.9:
      return const Text(
        "Overweight",
        style: TextStyle(color: Colors.amberAccent, fontSize: 15),
      );
    case > 30 && < 34.9:
      return const Text(
        "Obese",
        style: TextStyle(color: Colors.orange, fontSize: 15),
      );
    case > 35:
      return const Text(
        "Clinically Obese",
        style: TextStyle(color: Colors.red, fontSize: 15),
      );

    default:
      return const Text("");
  }
}
