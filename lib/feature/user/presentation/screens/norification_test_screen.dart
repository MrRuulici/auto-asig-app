import 'package:flutter/material.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({Key? key}) : super(key: key);

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  String _status = 'Ready to test';
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final enabled = await NotificationHelper.areNotificationsEnabled();
    final pending = await NotificationHelper.getPendingNotifications();
    
    setState(() {
      _status = enabled ? '✅ Notifications Enabled' : '❌ Notifications Disabled';
      _pendingCount = pending.length;
    });
  }

  Future<void> _testImmediateNotification() async {
    try {
      await NotificationHelper.showImmediateNotification(
        id: 999,
        title: 'Test Imediat',
        body: 'Această notificare ar trebui să apară imediat!',
        payload: 'test_immediate',
      );
      
      _showSnackBar('✅ Notificare imediată trimisă!');
    } catch (e) {
      _showSnackBar('❌ Eroare: $e');
    }
  }

  Future<void> _testScheduled5Seconds() async {
    try {
      final scheduledTime = DateTime.now().add(const Duration(seconds: 5));
      
      await NotificationHelper.scheduleNotification(
        id: 998,
        title: 'Test Programat (5 sec)',
        body: 'Această notificare a fost programată pentru ${scheduledTime.hour}:${scheduledTime.minute}:${scheduledTime.second}',
        dateTime: scheduledTime,
        payload: 'test_5sec',
      );
      
      _showSnackBar('✅ Notificare programată pentru 5 secunde!');
      await _checkStatus();
    } catch (e) {
      _showSnackBar('❌ Eroare: $e');
    }
  }

  Future<void> _testScheduled1Minute() async {
    try {
      final scheduledTime = DateTime.now().add(const Duration(minutes: 1));
      
      await NotificationHelper.scheduleNotification(
        id: 997,
        title: 'Test Programat (1 min)',
        body: 'Această notificare a fost programată pentru ${scheduledTime.hour}:${scheduledTime.minute}',
        dateTime: scheduledTime,
        payload: 'test_1min',
      );
      
      _showSnackBar('✅ Notificare programată pentru 1 minut!');
      await _checkStatus();
    } catch (e) {
      _showSnackBar('❌ Eroare: $e');
    }
  }

  Future<void> _testMultipleNotifications() async {
    try {
      // Schedule 3 notifications at different times
      for (int i = 0; i < 3; i++) {
        final scheduledTime = DateTime.now().add(Duration(seconds: 10 + (i * 5)));
        
        await NotificationHelper.scheduleNotification(
          id: 900 + i,
          title: 'Notificare Multiplă ${i + 1}',
          body: 'Aceasta este notificarea ${i + 1} din 3',
          dateTime: scheduledTime,
          payload: 'test_multi_$i',
        );
      }
      
      _showSnackBar('✅ 3 notificări programate (la 10, 15, 20 sec)!');
      await _checkStatus();
    } catch (e) {
      _showSnackBar('❌ Eroare: $e');
    }
  }

  Future<void> _showPendingNotifications() async {
    final pending = await NotificationHelper.getPendingNotifications();
    
    if (pending.isEmpty) {
      _showSnackBar('Nu există notificări programate');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notificări Programate (${pending.length})'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pending.length,
            itemBuilder: (context, index) {
              final notif = pending[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${notif.id}')),
                  title: Text(notif.title ?? 'No title'),
                  subtitle: Text(notif.body ?? 'No body'),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Închide'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelAllNotifications() async {
    try {
      await NotificationHelper.cancelAllNotifications();
      _showSnackBar('✅ Toate notificările au fost anulate!');
      await _checkStatus();
    } catch (e) {
      _showSnackBar('❌ Eroare: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notificări'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkStatus,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      _status,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Notificări programate: $_pendingCount',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Teste de Bază',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _testImmediateNotification,
              icon: const Icon(Icons.notifications_active),
              label: const Text('Notificare Imediată'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _testScheduled5Seconds,
              icon: const Icon(Icons.timer),
              label: const Text('Programează peste 5 secunde'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _testScheduled1Minute,
              icon: const Icon(Icons.access_time),
              label: const Text('Programează peste 1 minut'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Teste Avansate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _testMultipleNotifications,
              icon: const Icon(Icons.notifications),
              label: const Text('3 Notificări Multiple'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.orange,
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Administrare',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            OutlinedButton.icon(
              onPressed: _showPendingNotifications,
              icon: const Icon(Icons.list),
              label: const Text('Vezi Notificări Programate'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 8),
            
            OutlinedButton.icon(
              onPressed: _cancelAllNotifications,
              icon: const Icon(Icons.clear_all),
              label: const Text('Anulează Toate Notificările'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                foregroundColor: Colors.red,
              ),
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            
            // Instructions
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instrucțiuni de Testare:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. Pentru notificări imediate: apasă primul buton'),
                    Text('2. Pentru notificări programate: apasă și minimizează aplicația'),
                    Text('3. Notificările vor apărea la timpul programat'),
                    Text('4. Apasă pe notificare pentru a deschide aplicația'),
                    SizedBox(height: 8),
                    Text(
                      'Note:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('• Pe iOS, trebuie să dai permisiuni de notificări'),
                    Text('• Pe Android 13+, trebuie să dai permisiuni'),
                    Text('• Minimizează aplicația pentru a vedea notificările'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}