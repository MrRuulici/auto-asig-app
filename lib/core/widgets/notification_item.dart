// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class NotificationItem extends StatefulWidget {
//   final int index;
//   final DateTime selectedDate;
//   final bool sms;
//   final bool email;
//   final bool push;
//   final void Function(DateTime, bool, bool, bool) onNotificationUpdate;
//   final VoidCallback onNotificationRemove;

//   const NotificationItem({
//     super.key,
//     required this.index,
//     required this.selectedDate,
//     required this.sms,
//     required this.email,
//     required this.push,
//     required this.onNotificationUpdate,
//     required this.onNotificationRemove,
//   });

//   @override
//   _NotificationItemState createState() => _NotificationItemState();
// }

// class _NotificationItemState extends State<NotificationItem> {
//   late bool isSmsSelected;
//   late bool isEmailSelected;
//   late bool isPushSelected;

//   @override
//   void initState() {
//     super.initState();
//     isSmsSelected = widget.sms;
//     isEmailSelected = widget.email;
//     isPushSelected = widget.push;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Row for Date Picker and Time Picker
//             Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: InkWell(
//                     onTap: () async {
//                       DateTime? newDate = await showDatePicker(
//                         context: context,
//                         // initialDate: widget.selectedDate ??
//                         //     DateTime
//                         //         .now(), // Default to today if selectedDate is null
//                         initialDate:
//                             widget.selectedDate.isBefore(DateTime.now())
//                                 ? DateTime.now()
//                                 : widget.selectedDate,
//                         firstDate: DateTime.now(), // Minimum date is today
//                         lastDate: DateTime(2101), // Maximum date
//                       );

//                       if (newDate != null) {
//                         widget.onNotificationUpdate(
//                           newDate,
//                           isSmsSelected,
//                           isEmailSelected,
//                           isPushSelected,
//                         );
//                       } else {
//                         widget.onNotificationUpdate(
//                           // widget.selectedDate ??
//                           //     DateTime
//                           //         .now(), // Default to today if selectedDate is null
//                           widget.selectedDate,
//                           isSmsSelected,
//                           isEmailSelected,
//                           isPushSelected,
//                         );
//                       }
//                     },
//                     borderRadius: BorderRadius.circular(8),
//                     splashColor: Colors.indigoAccent.withOpacity(0.1),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.indigoAccent.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.calendar_today_outlined,
//                               color: Colors.indigoAccent),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               DateFormat('dd.MM.yyyy')
//                                   .format(widget.selectedDate),
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.indigoAccent,
//                                 fontWeight: FontWeight.bold,
//                                 decoration: TextDecoration.underline,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   flex: 2,
//                   child: InkWell(
//                     onTap: () async {
//                       TimeOfDay? time = await showTimePicker(
//                         context: context,
//                         initialTime:
//                             TimeOfDay.fromDateTime(widget.selectedDate),
//                       );
//                       if (time != null) {
//                         DateTime updatedDateTime = DateTime(
//                           widget.selectedDate.year,
//                           widget.selectedDate.month,
//                           widget.selectedDate.day,
//                           time.hour,
//                           time.minute,
//                         );
//                         widget.onNotificationUpdate(updatedDateTime,
//                             isSmsSelected, isEmailSelected, isPushSelected);
//                       }
//                     },
//                     borderRadius: BorderRadius.circular(8),
//                     splashColor: Colors.indigoAccent.withOpacity(0.1),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.indigoAccent.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.access_time,
//                               color: Colors.indigoAccent),
//                           const SizedBox(width: 8),
//                           Text(
//                             DateFormat('HH:mm').format(widget.selectedDate),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.indigoAccent,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Checkbox Row for SMS, Email, Push Notifications
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Column(
//                     children: [
//                       Checkbox(
//                         value: isSmsSelected,
//                         onChanged: (bool? value) {
//                           setState(() {
//                             isSmsSelected = value ?? false;
//                           });
//                           widget.onNotificationUpdate(widget.selectedDate,
//                               isSmsSelected, isEmailSelected, isPushSelected);
//                         },
//                       ),
//                       const Text('SMS'),
//                     ],
//                   ),
//                 ),
//                 Flexible(
//                   child: Column(
//                     children: [
//                       Checkbox(
//                         value: isEmailSelected,
//                         onChanged: (bool? value) {
//                           setState(() {
//                             isEmailSelected = value ?? false;
//                           });
//                           widget.onNotificationUpdate(widget.selectedDate,
//                               isSmsSelected, isEmailSelected, isPushSelected);
//                         },
//                       ),
//                       const Text('Email'),
//                     ],
//                   ),
//                 ),
//                 Flexible(
//                   child: Column(
//                     children: [
//                       Checkbox(
//                         value: isPushSelected,
//                         onChanged: (bool? value) {
//                           setState(() {
//                             isPushSelected = value ?? false;
//                           });
//                           widget.onNotificationUpdate(widget.selectedDate,
//                               isSmsSelected, isEmailSelected, isPushSelected);
//                         },
//                       ),
//                       const Text('Notificări Push'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const Divider(height: 24),

//             // Remove Notification Button
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton.icon(
//                 onPressed: widget.onNotificationRemove,
//                 icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//                 label: const Text(
//                   'Sterge',
//                   style: TextStyle(
//                     color: Colors.redAccent,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 style: TextButton.styleFrom(
//                   padding: EdgeInsets.zero,
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatefulWidget {
  final int index;
  final DateTime selectedDate;
  final bool sms;
  final bool email;
  final bool push;
  final void Function(DateTime, bool, bool, bool) onNotificationUpdate;
  final VoidCallback onNotificationRemove;

  const NotificationItem({
    super.key,
    required this.index,
    required this.selectedDate,
    required this.sms,
    required this.email,
    required this.push,
    required this.onNotificationUpdate,
    required this.onNotificationRemove,
  });

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late bool isSmsSelected;
  late bool isEmailSelected;
  late bool isPushSelected;

  @override
  void initState() {
    super.initState();
    isSmsSelected = widget.sms;
    isEmailSelected = widget.email;
    isPushSelected = widget.push;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notificare ${widget.index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: widget.onNotificationRemove,
                  icon: const Icon(
                    Icons.close_rounded,
                  ),
                  splashRadius: 20,
                ),
              ],
            ),

            // Row for Date Picker and Time Picker
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate:
                            widget.selectedDate.isBefore(DateTime.now())
                                ? DateTime.now()
                                : widget.selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (newDate != null) {
                        widget.onNotificationUpdate(
                          newDate,
                          isSmsSelected,
                          isEmailSelected,
                          isPushSelected,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd.MM.yyyy').format(widget.selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            color: buttonBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay.fromDateTime(widget.selectedDate),
                      );
                      if (time != null) {
                        DateTime updatedDateTime = DateTime(
                          widget.selectedDate.year,
                          widget.selectedDate.month,
                          widget.selectedDate.day,
                          time.hour,
                          time.minute,
                        );
                        widget.onNotificationUpdate(updatedDateTime,
                            isSmsSelected, isEmailSelected, isPushSelected);
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('HH:mm').format(widget.selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            color: buttonBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Checkbox Row for SMS, Email, Push Notifications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Checkbox(
                        value: isPushSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            isPushSelected = value ?? false;
                          });
                          widget.onNotificationUpdate(widget.selectedDate,
                              isSmsSelected, isEmailSelected, isPushSelected);
                        },
                      ),
                      const Text('Notificări Push'),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      Checkbox(
                        value: isEmailSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            isEmailSelected = value ?? false;
                          });
                          widget.onNotificationUpdate(widget.selectedDate,
                              isSmsSelected, isEmailSelected, isPushSelected);
                        },
                      ),
                      const Text('Email'),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      Checkbox(
                        value: isSmsSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            isSmsSelected = value ?? false;
                          });
                          widget.onNotificationUpdate(widget.selectedDate,
                              isSmsSelected, isEmailSelected, isPushSelected);
                        },
                      ),
                      const Text(
                        'SMS',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
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
