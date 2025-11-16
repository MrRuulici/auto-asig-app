part of 'car_info_cubit.dart';

class CarInfoState extends Equatable {
  const CarInfoState({
    required this.carNr,
    required this.vehicleModel,
    this.expirationDateITP,
    this.expirationDateRCA,
    this.expirationDateCASCO,
    this.expirationDateRovinieta,
    this.expirationDateTahograf,
    this.notificationsITP = const [],
    this.notificationsRCA = const [],
    this.notificationsCASCO = const [],
    this.notificationsRovinieta = const [],
    this.notificationsTahograf = const [],
    this.distributionJournalEntry,
    this.breaksJournalEntry,
    this.serviceJournalEntry,
    this.journalEntriesService = const [],
    this.journalEntriesBreaks = const [],
    this.journalEntriesDistribution = const [],
  });

  final String carNr;
  final String vehicleModel;
  final DateTime? expirationDateITP;
  final DateTime? expirationDateRCA;
  final DateTime? expirationDateCASCO;
  final DateTime? expirationDateRovinieta;
  final DateTime? expirationDateTahograf;

  // Lists for notifications
  final List<NotificationModel> notificationsITP;
  final List<NotificationModel> notificationsRCA;
  final List<NotificationModel> notificationsCASCO;
  final List<NotificationModel> notificationsRovinieta;
  final List<NotificationModel> notificationsTahograf;

  // Journal - old single entries (kept for compatibility)
  final JournalEntry? distributionJournalEntry;
  final JournalEntry? breaksJournalEntry;
  final JournalEntry? serviceJournalEntry;

  // Journal - new lists for multiple entries
  final List<JournalEntry> journalEntriesService;
  final List<JournalEntry> journalEntriesBreaks;
  final List<JournalEntry> journalEntriesDistribution;

  CarInfoState copyWith({
    String? carNr,
    String? vehicleModel,
    DateTime? expirationDateITP,
    DateTime? expirationDateRCA,
    DateTime? expirationDateCASCO,
    DateTime? expirationDateRovinieta,
    DateTime? expirationDateTahograf,
    List<NotificationModel>? notificationsITP,
    List<NotificationModel>? notificationsRCA,
    List<NotificationModel>? notificationsCASCO,
    List<NotificationModel>? notificationsRovinieta,
    List<NotificationModel>? notificationsTahograf,
    List<JournalEntry>? journalEntriesService,
    List<JournalEntry>? journalEntriesBreaks,
    List<JournalEntry>? journalEntriesDistribution,
  }) {
    return CarInfoState(
      carNr: carNr ?? this.carNr,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      expirationDateITP: expirationDateITP ?? this.expirationDateITP,
      expirationDateRCA: expirationDateRCA ?? this.expirationDateRCA,
      expirationDateCASCO: expirationDateCASCO ?? this.expirationDateCASCO,
      expirationDateRovinieta:
          expirationDateRovinieta ?? this.expirationDateRovinieta,
      expirationDateTahograf:
          expirationDateTahograf ?? this.expirationDateTahograf,
      notificationsITP: notificationsITP ?? this.notificationsITP,
      notificationsRCA: notificationsRCA ?? this.notificationsRCA,
      notificationsCASCO: notificationsCASCO ?? this.notificationsCASCO,
      notificationsRovinieta:
          notificationsRovinieta ?? this.notificationsRovinieta,
      notificationsTahograf:
          notificationsTahograf ?? this.notificationsTahograf,
      distributionJournalEntry: distributionJournalEntry,
      breaksJournalEntry: breaksJournalEntry,
      serviceJournalEntry: serviceJournalEntry,
      journalEntriesService: journalEntriesService ?? this.journalEntriesService,
      journalEntriesBreaks: journalEntriesBreaks ?? this.journalEntriesBreaks,
      journalEntriesDistribution: journalEntriesDistribution ?? this.journalEntriesDistribution,
    );
  }

  CarInfoState clearSelectedExpirationDates({
    bool clearITP = false,
    bool clearRCA = false,
    bool clearCASCO = false,
    bool clearRovinieta = false,
    bool clearTahograf = false,
  }) {
    return CarInfoState(
      carNr: carNr,
      vehicleModel: vehicleModel,
      expirationDateITP: clearITP ? null : expirationDateITP,
      expirationDateRCA: clearRCA ? null : expirationDateRCA,
      expirationDateCASCO: clearCASCO ? null : expirationDateCASCO,
      expirationDateRovinieta: clearRovinieta ? null : expirationDateRovinieta,
      expirationDateTahograf: clearTahograf ? null : expirationDateTahograf,
      notificationsITP: clearITP ? [] : notificationsITP,
      notificationsRCA: clearRCA ? [] : notificationsRCA,
      notificationsCASCO: clearCASCO ? [] : notificationsCASCO,
      notificationsRovinieta: clearRovinieta ? [] : notificationsRovinieta,
      notificationsTahograf: clearTahograf ? [] : notificationsTahograf,
      distributionJournalEntry: distributionJournalEntry,
      breaksJournalEntry: breaksJournalEntry,
      serviceJournalEntry: serviceJournalEntry,
      journalEntriesService: journalEntriesService,
      journalEntriesBreaks: journalEntriesBreaks,
      journalEntriesDistribution: journalEntriesDistribution,
    );
  }

  @override
  List<Object?> get props => [
        carNr,
        vehicleModel,
        expirationDateITP,
        expirationDateRCA,
        expirationDateCASCO,
        expirationDateRovinieta,
        expirationDateTahograf,
        notificationsITP,
        notificationsRCA,
        notificationsCASCO,
        notificationsRovinieta,
        notificationsTahograf,
        journalEntriesService,
        journalEntriesBreaks,
        journalEntriesDistribution,
      ];
}