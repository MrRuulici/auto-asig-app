import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_appbar.dart';
import 'package:auto_asig/feature/home/presentation/screens/home_screen.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/cubit/vehicle_journals_cubit.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/widgets/journal_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleJournalScreen extends StatelessWidget {
  const VehicleJournalScreen({super.key});

  static const String path = 'journalScreen';
  static const String absolutePath = '${HomeScreen.path}/$path';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AlliatAppBar(),
      body: BlocBuilder<VehicleJournalsCubit, VehicleJournalsState>(
        builder: (context, state) {
          if (state is VehicleJournalsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleJournalsError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is VehicleJournalsLoaded) {
            final journals = state.journals;

            if (journals.isEmpty) {
              return const Center(
                child: Text('Nu există jurnale disponibile.'),
              );
            }

            return Column(
              children: [
                // Header with car info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [logoBlue, logoBlue.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.carLicense.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.carModel.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Journal list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: journals.length,
                    itemBuilder: (context, index) {
                      final journalType = journals.keys.elementAt(index);
                      final entries = journals[journalType]!;
                      final vehicleId = '${state.carLicense}-${state.carModel}';

                      return JournalCategory(
                        type: journalType,
                        entries: entries,
                        vehicleId: vehicleId,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// class VehicleJournalScreen extends StatelessWidget {
//   const VehicleJournalScreen({super.key});

//   static const String path = 'journalScreen';
//   static const String absolutePath = '${HomeScreen.path}/$path';

//   // Simulated data fetching function
//   Future<Map<JournalEntryType, List<JournalEntry>>> _fetchJournals() async {
//     // Simulated journal data
//     return {
//       JournalEntryType.breaks: [
//         JournalEntry(
//           entryId: '1',
//           name: 'Brake Pad Replacement',
//           createdAt: Timestamp.now(),
//           editedAt: Timestamp.now(),
//           type: JournalEntryType.breaks,
//           date: DateTime.now().subtract(const Duration(days: 10)),
//           kms: 25000,
//         ),
//       ],
//       JournalEntryType.distribution: [
//         JournalEntry(
//           entryId: '2',
//           name: 'Replace Distribution Belt',
//           createdAt: Timestamp.now(),
//           editedAt: Timestamp.now(),
//           type: JournalEntryType.distribution,
//           date: DateTime.now().subtract(const Duration(days: 20)),
//           kms: 50000,
//         ),
//       ],
//       JournalEntryType.service: [
//         JournalEntry(
//           entryId: '3',
//           name: 'Oil Change',
//           createdAt: Timestamp.now(),
//           editedAt: Timestamp.now(),
//           type: JournalEntryType.service,
//           date: DateTime.now().subtract(const Duration(days: 30)),
//           kms: 15000,
//         ),
//         JournalEntry(
//           entryId: '4',
//           name: 'Tire Rotation',
//           createdAt: Timestamp.now(),
//           editedAt: Timestamp.now(),
//           type: JournalEntryType.service,
//           date: DateTime.now().subtract(const Duration(days: 50)),
//           kms: 20000,
//         ),
//       ],
//       JournalEntryType.other: [],
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AlliatAppBar(),
//       body: FutureBuilder<Map<JournalEntryType, List<JournalEntry>>>(
//         future: _fetchJournals(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(
//               child: Text('Error fetching journals. Please try again.'),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text('No journals available.'),
//             );
//           } else {

//             final journals = snapshot.data!;
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: journals.length,
//               itemBuilder: (context, index) {
//                 final journalType = journals.keys.elementAt(index);
//                 final entries = journals[journalType]!;

//                 return JournalCategory(
//                   type: journalType,
//                   entries: entries,
//                   vehicleId:  ,
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
