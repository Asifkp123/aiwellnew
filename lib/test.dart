import 'package:flutter/material.dart';

class MoodCheckInPage extends StatefulWidget {
  @override
  _MoodCheckInPageState createState() => _MoodCheckInPageState();
}

class _MoodCheckInPageState extends State<MoodCheckInPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<String> _moodOptions = [
    'Happy', 'Sad', 'Angry', 'Anxious', 'Calm', 'Confused', 'Tired', 'Excited'
  ];
  final List<String> _displayedMoods = [];

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    for (int i = 0; i < _moodOptions.length; i++) {
      await Future.delayed(Duration(milliseconds: 150));
      _displayedMoods.insert(i, _moodOptions[i]);
      _listKey.currentState?.insertItem(i);
    }
  }

  Widget _buildItem(String mood, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1, 0), // Slide from right
        end: Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            title: Text(mood, style: TextStyle(fontWeight: FontWeight.w500)),
            trailing: Icon(Icons.circle_outlined),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("How has your mood\nbeen lately?",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              SizedBox(height: 12),
              Text("Quick check-in before we get started.",
                  style: TextStyle(color: Colors.grey.shade600)),
              SizedBox(height: 20),
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: _displayedMoods.length,
                  itemBuilder: (context, index, animation) {
                    return _buildItem(_displayedMoods[index], animation);
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
