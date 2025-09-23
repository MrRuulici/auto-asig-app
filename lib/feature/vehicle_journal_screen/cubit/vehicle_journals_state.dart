part of 'vehicle_journals_cubit.dart';

sealed class VehicleJournalsState extends Equatable {
  const VehicleJournalsState();

  @override
  List<Object?> get props => [];
}

final class VehicleJournalsInitial extends VehicleJournalsState {}

final class VehicleJournalsLoaded extends VehicleJournalsState {
  final Map<JournalEntryType, List<JournalEntry>> journals;
  final String carModel;
  final String carLicense;

  const VehicleJournalsLoaded({
    required this.journals,
    required this.carModel,
    required this.carLicense,
  });

  @override
  List<Object?> get props => [journals, carModel, carLicense];
}

final class VehicleJournalsError extends VehicleJournalsState {
  final String message;

  const VehicleJournalsError(this.message);

  @override
  List<Object?> get props => [message];
}
