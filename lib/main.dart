import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(MyApp());

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      //systemNavigationBarColor: Colors.black.withOpacity(0.002),
      systemNavigationBarColor: Colors.transparent,
    ),
  );
}

Color brandColor = const Color(0xFF0dd1a3);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
            lightColorScheme = lightDynamic.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          } else {
            lightColorScheme = ColorScheme.fromSeed(seedColor: brandColor);
            darkColorScheme = ColorScheme.fromSeed(seedColor: brandColor, brightness: Brightness.dark);
          }

        lightColorScheme = ColorScheme.fromSeed(seedColor: brandColor);
        darkColorScheme = ColorScheme.fromSeed(seedColor: brandColor, brightness: Brightness.dark);

        return MaterialApp(
          title: 'Assignment Score Calculator',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              scaffoldBackgroundColor: lightColorScheme.background,
              primaryTextTheme: TextTheme(
                titleLarge: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: lightColorScheme.surface,
                foregroundColor: lightColorScheme.onPrimaryContainer
              ),
              textTheme: TextTheme(
                  labelLarge: TextStyle(color: lightColorScheme.onPrimary)
              ),
              checkboxTheme: CheckboxThemeData(
                checkColor: MaterialStateProperty.all(lightColorScheme.onPrimary),
              ),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: lightColorScheme.primary,
              ),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: lightColorScheme.primary),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: lightColorScheme.primary),
                ),
              )
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            scaffoldBackgroundColor: darkColorScheme.background,
            primaryTextTheme: TextTheme(
              titleLarge: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: darkColorScheme.surface,
              foregroundColor: darkColorScheme.onPrimaryContainer,
            ),
            textTheme: TextTheme(
                labelLarge: TextStyle(color: darkColorScheme.onPrimary)
            ),
            checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStateProperty.all(lightColorScheme.onPrimary),
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: darkColorScheme.primary,
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: darkColorScheme.primary),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: darkColorScheme.primary),
              ),
            )
          ),
          home: AssignmentNumberScreen(),
        );
      }
    );
  }
}

class AssignmentNumberScreen extends StatefulWidget {
  @override
  _AssignmentNumberScreenState createState() => _AssignmentNumberScreenState();
}

class _AssignmentNumberScreenState extends State<AssignmentNumberScreen> {
  final TextEditingController numberController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment Score Calculator', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "How many assignments?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: "Enter number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  prefixIcon: Icon(Icons.format_list_numbered, color: Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  int? numAssignments = int.tryParse(numberController.text);
                  if (numAssignments != null && numAssignments > 0) {
                    setState(() {
                      errorMessage = null;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignmentDetailsScreen(
                          numAssignments: numAssignments,
                        ),
                      ),
                    );
                  } else {
                    setState(() {
                      errorMessage = "Please enter a valid number of assignments.";
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignmentTile extends StatefulWidget {
  final Map<String, dynamic?> assignmentData;
  final int assignmentNumber;

  AssignmentTile({required this.assignmentData, required this.assignmentNumber});

  @override
  _AssignmentTileState createState() => _AssignmentTileState();
}

class _AssignmentTileState extends State<AssignmentTile> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(
            "Assignment ${widget.assignmentNumber}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) {
                    widget.assignmentData['score'] = double.tryParse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Score", labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    " / ",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: TextField(
                  onChanged: (value) {
                    widget.assignmentData['out_of'] = double.tryParse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Possible Score", labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (value) {
              widget.assignmentData['weight'] = double.tryParse(value);
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Weight (%)", labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Scrap this assignment?", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              Checkbox(
                value: widget.assignmentData['scrapped'],
                onChanged: (value) {
                  setState(() {
                    widget.assignmentData['scrapped'] = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AssignmentDetailsScreen extends StatefulWidget {
  final int numAssignments;

  AssignmentDetailsScreen({required this.numAssignments});

  @override
  _AssignmentDetailsScreenState createState() => _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen> {
  late List<Map<String, dynamic?>> assignments;
  final TextEditingController targetPercentageController = TextEditingController();
  int? selectedAssignmentIndex;
  double? requiredScore;
  int dynamicNumAssignments = 0;

  @override
  void initState() {
    super.initState();
    dynamicNumAssignments = widget.numAssignments;
    assignments = List.generate(widget.numAssignments, (index) => {
      'score': null,
      'out_of': null,
      'weight': null,
      'scrapped': false,
    });
  }

  void calculateRequiredScoreForPass() {
    double totalWeightAchieved = 0.0;
    double totalWeightPossible = 0.0;
    double targetPercentage = double.tryParse(targetPercentageController.text) ?? 0.0;

    for (var i = 0; i < assignments.length; i++) {
      if (assignments[i]['scrapped'] || i == selectedAssignmentIndex) {
        continue;
      }

      double score = assignments[i]['score'] ?? 0.0;
      double outOf = assignments[i]['out_of'] ?? 0.0;
      double weight = assignments[i]['weight'] ?? 0.0;

      if (outOf > 0) {  // To avoid division by zero
        totalWeightAchieved += (score / outOf) * weight;
      }
      totalWeightPossible += weight;
    }

    double requiredWeightedScore = targetPercentage - totalWeightAchieved;
    double remainingWeight = 100 - totalWeightPossible;

    double assignmentOutOf = assignments[selectedAssignmentIndex!]['out_of'] ?? 100.0;  // Assuming a default of 100 if not provided

    if (remainingWeight <= 0 || assignmentOutOf <= 0) {
      requiredScore = null;
    } else {
      requiredScore = requiredWeightedScore / remainingWeight * assignmentOutOf;
    }

    setState(() {}); // to refresh the UI
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Assignment Details", style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
        //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: NotificationListener<KeepAliveNotification>(
        onNotification: (notification) {
          return true;
        },
        child: ListView.builder(
          addAutomaticKeepAlives: true,
          padding: const EdgeInsets.all(16),
          itemCount: dynamicNumAssignments + 1, // Use dynamicNumAssignments
          itemBuilder: (context, index) {
            // If this is the last item, show the add assignment button
            if (index == dynamicNumAssignments) {
              return ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    dynamicNumAssignments++;
                    assignments.add({
                      'score': null,
                      'out_of': null,
                      'weight': null,
                      'scrapped': false,
                    });
                  });
                },
                icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                label: Text("Add Another Assignment", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                )
              );
            }
            // Otherwise, show the assignment tile as usual
            return AssignmentTile(
              assignmentData: assignments[index],
              assignmentNumber: index + 1,
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: targetPercentageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Target Total %",
                        hintText: "E.g., 50",
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),  // Teal colored text
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondaryContainer),  // Teal border when focused
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.onSecondaryContainer, width: 0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButton<int>(
                      borderRadius: BorderRadius.circular(10.0),
                      value: selectedAssignmentIndex,
                      hint: Text("Select assignment", style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
                      underline: SizedBox.shrink(),  // Removing underline
                      items: List.generate(dynamicNumAssignments, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              "Assignment ${index + 1}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          selectedAssignmentIndex = value;
                          requiredScore = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),  // Spacing
              ElevatedButton(
                onPressed: () {
                  calculateRequiredScoreForPass();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )// Text color
                ),
                child: Text("Calculate Required Score"),
              ),
              SizedBox(height: 10),  // Spacing
              if (requiredScore != null)
                Text(
                  "You need a score of ${requiredScore!.toStringAsFixed(2)} on Assignment ${selectedAssignmentIndex! + 1} to achieve ${targetPercentageController.text}% overall.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            // calculate percentage
            double totalWeightAchieved = 0.0;
            double totalWeightPossible = 0.0;
            for (var i = 0; i < assignments.length; i++) {
              if (assignments[i]['scrapped']) {
                continue;
              }
              if (assignments[i]['score'] != null && assignments[i]['out_of'] != null && assignments[i]['weight'] != null) {
                totalWeightAchieved += (assignments[i]['score']! / assignments[i]['out_of']!) * assignments[i]['weight']!;
                totalWeightPossible += assignments[i]['weight']!;
              }
            }
            double overallPercentage = totalWeightPossible == 0.0 ? 0.0 : totalWeightAchieved / totalWeightPossible * 100;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.analytics_outlined, color: Theme.of(context).colorScheme.primary),
                      SizedBox(width: 20),
                      Text("Overall Percentage", style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
                    ],
                  ),
                  content: Text(
                    "${overallPercentage.toStringAsFixed(2)}%",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text("OK", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.calculate, color: Theme.of(context).colorScheme.onPrimary, size: 30),
        ),
      ),
    );
  }
}
