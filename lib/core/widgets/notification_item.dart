import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {
  final int index;
  final DateTime expirationDate;
  final bool monthBefore;
  final bool weekBefore;
  final bool dayBefore;
  final bool email;
  final bool push;
  final void Function(bool monthBefore, bool weekBefore, bool dayBefore, bool email, bool push) onNotificationUpdate;
  final VoidCallback onNotificationRemove;

  const NotificationItem({
    super.key,
    required this.index,
    required this.expirationDate,
    this.monthBefore = false,
    this.weekBefore = false,
    this.dayBefore = false,
    this.email = false,
    this.push = false,
    required this.onNotificationUpdate,
    required this.onNotificationRemove,
  });

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late bool isEmailSelected;
  late bool isPushSelected;
  late bool isMonthBefore;
  late bool isWeekBefore;
  late bool isDayBefore;

  @override
  void initState() {
    super.initState();
    _syncWithWidget();
  }

  @override
  void didUpdateWidget(NotificationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync internal state when widget props change
    if (oldWidget.email != widget.email ||
        oldWidget.push != widget.push ||
        oldWidget.monthBefore != widget.monthBefore ||
        oldWidget.weekBefore != widget.weekBefore ||
        oldWidget.dayBefore != widget.dayBefore) {
      _syncWithWidget();
    }
  }

  void _syncWithWidget() {
    isEmailSelected = widget.email;
    isPushSelected = widget.push;
    isMonthBefore = widget.monthBefore;
    isWeekBefore = widget.weekBefore;
    isDayBefore = widget.dayBefore;
  }

  void _notifyUpdate() {
    widget.onNotificationUpdate(
      isMonthBefore,
      isWeekBefore,
      isDayBefore,
      isEmailSelected,
      isPushSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: textFieldGrey,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with Title and Remove Button
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notificare',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Time Period Selection
            const Text(
              'Alege când să primești notificarea:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Checkbox for Month Before
            CheckboxListTile(
              value: isMonthBefore,
              onChanged: (bool? value) {
                setState(() {
                  isMonthBefore = value ?? false;
                });
                _notifyUpdate();
              },
              title: const Text('O lună înainte'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            // Checkbox for Week Before
            CheckboxListTile(
              value: isWeekBefore,
              onChanged: (bool? value) {
                setState(() {
                  isWeekBefore = value ?? false;
                });
                _notifyUpdate();
              },
              title: const Text('O săptămână înainte'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            // Checkbox for Day Before
            CheckboxListTile(
              value: isDayBefore,
              onChanged: (bool? value) {
                setState(() {
                  isDayBefore = value ?? false;
                });
                _notifyUpdate();
              },
              title: const Text('O zi înainte'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),

            // Notification Type Selection
            const Text(
              'Tip notificare:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Checkbox Row for Email and Push Notifications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: CheckboxListTile(
                    value: isPushSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        isPushSelected = value ?? false;
                      });
                      _notifyUpdate();
                    },
                    title: const Text(
                      'Push',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Flexible(
                  child: CheckboxListTile(
                    value: isEmailSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        isEmailSelected = value ?? false;
                      });
                      _notifyUpdate();
                    },
                    title: const Text(
                      'Email',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}