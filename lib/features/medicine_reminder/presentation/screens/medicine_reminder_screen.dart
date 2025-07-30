import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineReminderScreen extends StatefulWidget {
  static const String routeName = '/medicineReminder';



  @override
  _MedicineReminderState createState() => _MedicineReminderState();
}

class _MedicineReminderState extends State<MedicineReminderScreen> {
  final _channel = MethodChannel('com.qurig.aiwel/notifications');
  final _medicineController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _time;
  List<Map<String, dynamic>> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> _handleMethod(MethodCall call) async {
    if (call.method == 'markMedicineTaken') {
      final String id = call.arguments['id'];
      await _updateMedicineStatus(id, true);
      setState(() {});
    }
  }

  Future<void> _loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final schedulesJson = prefs.getString('schedules') ?? '[]';
    setState(() {
      _schedules = List<Map<String, dynamic>>.from(jsonDecode(schedulesJson));
    });
  }

  Future<void> _saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('schedules', jsonEncode(_schedules));
  }

  Future<void> _updateMedicineStatus(String id, bool taken) async {
    setState(() {
      final schedule = _schedules.firstWhere((s) => s['id'] == id);
      schedule['status'] = taken;
    });
    await _saveSchedules();
  }

  Future<void> _scheduleNotification() async {
    final now = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30)); // Convert to IST
    _startDate = now;
    _endDate = now.add(Duration(days: 1));
    _time = TimeOfDay(hour: now.hour, minute: now.minute + 3); // 3 minutes from now (e.g., 06:35 AM IST)
    _medicineController.text = "Test Medicine";

    if (_medicineController.text.isEmpty || _startDate == null || _endDate == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final schedule = {
      'id': id,
      'medicine': _medicineController.text,
      'startDate': _startDate!.toIso8601String(),
      'endDate': _endDate!.toIso8601String(),
      'time': '${_time!.hour}:${_time!.minute}',
      'status': false,
    };

    setState(() {
      _schedules.add(schedule);
    });
    await _saveSchedules();

    try {
      print('Scheduling notification: $schedule');
      await _channel.invokeMethod('scheduleNotification', {
        'id': id,
        'medicine': _medicineController.text,
        'startDate': _startDate!.toIso8601String(),
        'endDate': _endDate!.toIso8601String(),
        'hour': _time!.hour,
        'minute': _time!.minute,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notification scheduled')));
    } catch (e) {
      print('Error scheduling notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error scheduling notification: $e')));
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medicine Reminder')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _medicineController,
              decoration: InputDecoration(labelText: 'Medicine Name'),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_startDate == null ? 'Select Start Date' : _startDate.toString()),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text('Pick Start Date'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_endDate == null ? 'Select End Date' : _endDate.toString()),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text('Pick End Date'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_time == null ? 'Select Time' : _time!.format(context)),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Pick Time'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: Text('Schedule Notification'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _schedules.length,
                itemBuilder: (context, index) {
                  final schedule = _schedules[index];
                  return ListTile(
                    title: Text(schedule['medicine']),
                    subtitle: Text(
                        'From: ${schedule['startDate']} To: ${schedule['endDate']} at ${schedule['time']} | Taken: ${schedule['status']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}