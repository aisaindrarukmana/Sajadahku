class PrayerSchedule {
  final int? id;
  final String date;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const PrayerSchedule({
    this.id,
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  Map<String, Object?> toMap() => {
    'id': id, 'date': date, 'fajr': fajr, 'dhuhr': dhuhr,
    'asr': asr, 'maghrib': maghrib, 'isha': isha,
  };

  factory PrayerSchedule.fromMap(Map<String, Object?> map) => PrayerSchedule(
    id: map['id'] as int?,
    date: map['date'] as String,
    fajr: map['fajr'] as String,
    dhuhr: map['dhuhr'] as String,
    asr: map['asr'] as String,
    maghrib: map['maghrib'] as String,
    isha: map['isha'] as String,
  );
}

class PrayerAttendance {
  final int? id;
  final String date;
  final String prayer;
  final String status;
  final String note;

  const PrayerAttendance({
    this.id,
    required this.date,
    required this.prayer,
    required this.status,
    this.note = '',
  });

  Map<String, Object?> toMap() => {
    'id': id, 'date': date, 'prayer': prayer,
    'status': status, 'note': note,
  };

  factory PrayerAttendance.fromMap(Map<String, Object?> map) => PrayerAttendance(
    id: map['id'] as int?,
    date: map['date'] as String,
    prayer: map['prayer'] as String,
    status: map['status'] as String,
    note: (map['note'] as String?) ?? '',
  );
}
