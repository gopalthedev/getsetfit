import 'package:flutter/material.dart';

class FitnessCoaching extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FitnessCoachingPage();
  }
}

class FitnessCoachingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Coaching'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome to Fitness Coaching!',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Get Fit, Stay Healthy!',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Tips for a Healthy Lifestyle:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Stay hydrated by drinking plenty of water.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Eat a balanced diet with plenty of fruits and vegetables.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Get at least 30 minutes of exercise every day.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Get enough sleep each night (7-9 hours for adults).'),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Benefits of Regular Exercise:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Improved cardiovascular health and reduced risk of heart disease.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Increased muscle strength and endurance.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Better mood and reduced stress levels.'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Weight management and increased metabolism.'),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Choose a category to start your workout:',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            CategoryButton(
              title: 'Cardio',
              onPressed: () {
                // Handle category selection
              },
            ),
            CategoryButton(
              title: 'Strength Training',
              onPressed: () {
                // Handle category selection
              },
            ),
            CategoryButton(
              title: 'Flexibility',
              onPressed: () {
                // Handle category selection
              },
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Featured Workout Plans:',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            WorkoutPlanCard(
              title: '30-Day Cardio Challenge',
              description: 'Improve your cardiovascular health with this intense cardio challenge!',
              onPressed: () {
                // Handle workout plan selection
              },
            ),
            WorkoutPlanCard(
              title: 'Beginner Strength Training',
              description: 'Start building strength with this beginner-friendly workout plan.',
              onPressed: () {
                // Handle workout plan selection
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CategoryButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}

class WorkoutPlanCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const WorkoutPlanCard({super.key, required this.title, required this.description, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
