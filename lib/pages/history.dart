import 'package:flutter/material.dart';
import 'package:getsetfit/models/activitesData.dart';
import 'package:intl/intl.dart';

class FitnessHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FitnessHistoryPage();
  }
}

class FitnessHistoryPage extends StatefulWidget {
  @override
  _FitnessHistoryPageState createState() => _FitnessHistoryPageState();
}

class _FitnessHistoryPageState extends State<FitnessHistoryPage> {
  List<ActivityEntry> activityEntries = [];

  @override
  void initState() {
    super.initState();
    loadActivityEntries();
  }

  void loadActivityEntries() {
    // Fetch existing activity entries from database or storage
    // For demo purpose, we are adding sample data here
    List<ActivityEntry> existingEntries = [];

    // Check if a new day has started
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);
    String? lastEntryDate = existingEntries.isNotEmpty ? existingEntries.last.date : null;

    if (lastEntryDate != today) {
      // If a new day has started, add a new entry with default values
      activityEntries.addAll(existingEntries);
      activityEntries.add(ActivityEntry(date: today, steps: MyActivities.steps, pushUps: MyActivities.pushUps, ropeJump: MyActivities.ropeJumps)); // Default steps count is 0
      // Save the updated activity entries to the database or storage
      // Here you should write the logic to save data to your database or storage
    } else {
      // If it's the same day, load the existing entries
      activityEntries.addAll(existingEntries);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness History'),
      ),
      body: ListView.builder(
        itemCount: activityEntries.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text('Date: ${activityEntries[index].date}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Steps: ${activityEntries[index].steps.toString()}', style: TextStyle(fontSize: 18),),
                    Text('PushUps: ${activityEntries[index].pushUps.toString()}',  style: TextStyle(fontSize: 18)),
                    Text('RopeJumps: ${activityEntries[index].ropeJump.toString()}',  style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActivityEntry {
  final String date;
  final double steps;
  final double pushUps;
  final double ropeJump;

  ActivityEntry({required this.date, required this.steps, required this.pushUps, required this.ropeJump,});
}
