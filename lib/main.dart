import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'repository.dart';

void main() => runApp(const SajadahKuApp());

const prayers = ['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya'];
const statuses = ['Tepat waktu', 'Terlambat', 'Tidak sholat', 'Berhalangan'];

String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class SajadahKuApp extends StatefulWidget {
  const SajadahKuApp({super.key});
  @override
  State<SajadahKuApp> createState() => _SajadahKuAppState();
}

class _SajadahKuAppState extends State<SajadahKuApp> {
  bool dark = false;
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => dark = prefs.getBool('dark') ?? false);
  }
  Future<void> _setTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark', value);
    setState(() => dark = value);
  }
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SajadahKu',
    debugShowCheckedModeBanner: false,
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    theme: ThemeData(colorSchemeSeed: const Color(0xff98704f), useMaterial3: true),
    darkTheme: ThemeData(colorSchemeSeed: const Color(0xffb99570), brightness: Brightness.dark, useMaterial3: true),
    home: HomePage(dark: dark, onThemeChanged: _setTheme),
  );
}

class HomePage extends StatefulWidget {
  final bool dark;
  final ValueChanged<bool> onThemeChanged;
  const HomePage({super.key, required this.dark, required this.onThemeChanged});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repo = SajadahRepository();
  int tab = 0;
  String name = 'Pengguna';
  DateTime selected = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadName();
  }
  Future<void> _loadName() async {
    final p = await SharedPreferences.getInstance();
    if (mounted) setState(() => name = p.getString('name') ?? 'Pengguna');
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _dashboard(),
      SchedulePage(repo: repo),
      AttendancePage(repo: repo),
      HistoryPage(repo: repo),
      SettingsPage(name: name, dark: widget.dark, onThemeChanged: widget.onThemeChanged,
        onNameChanged: (v) async {
          final p = await SharedPreferences.getInstance();
          await p.setString('name', v);
          if (mounted) setState(() => name = v);
        }),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('SajadahKu'), centerTitle: false),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.schedule), label: 'Jadwal'),
          NavigationDestination(icon: Icon(Icons.check_circle_outline), label: 'Presensi'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Riwayat'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Pengaturan'),
        ],
      ),
    );
  }

  Widget _dashboard() => FutureBuilder<List<PrayerSchedule>>(
    future: repo.getSchedules(),
    builder: (context, snap) {
      final today = dateKey(DateTime.now());
      final schedule = (snap.data ?? []).where((s) => s.date == today).firstOrNull;
      return ListView(padding: const EdgeInsets.all(16), children: [
        Text('Assalamu’alaikum, $name', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('Semoga harimu dipenuhi keberkahan.'),
        const SizedBox(height: 20),
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jadwal sholat hari ini', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (schedule == null)
              const Text('Belum ada jadwal untuk hari ini. Tambahkan melalui menu Jadwal.')
            else
              ...List.generate(5, (i) {
                final times = [schedule.fajr, schedule.dhuhr, schedule.asr, schedule.maghrib, schedule.isha];
                return ListTile(contentPadding: EdgeInsets.zero, title: Text(prayers[i]), trailing: Text(times[i], style: const TextStyle(fontWeight: FontWeight.bold)));
              }),
          ],
        ))),
        const SizedBox(height: 12),
        Card(child: ListTile(
          leading: const Icon(Icons.event_available),
          title: const Text('Catat presensi sholat'),
          subtitle: const Text('Simpan status sholat harianmu.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => setState(() => tab = 2),
        )),
      ]);
    },
  );
}

class SchedulePage extends StatefulWidget {
  final SajadahRepository repo;
  const SchedulePage({super.key, required this.repo});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}
class _SchedulePageState extends State<SchedulePage> {
  Future<void> _edit([PrayerSchedule? old]) async {
    final date = old?.date ?? dateKey(DateTime.now());
    final controllers = [
      TextEditingController(text: old?.fajr ?? '04:30'),
      TextEditingController(text: old?.dhuhr ?? '12:00'),
      TextEditingController(text: old?.asr ?? '15:15'),
      TextEditingController(text: old?.maghrib ?? '17:45'),
      TextEditingController(text: old?.isha ?? '19:00'),
    ];
    final result = await showDialog<PrayerSchedule>(context: context, builder: (ctx) => AlertDialog(
      title: Text(old == null ? 'Tambah jadwal' : 'Ubah jadwal'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        ...List.generate(5, (i) => TextField(
          controller: controllers[i],
          readOnly: true,
          decoration: InputDecoration(labelText: prayers[i], suffixIcon: const Icon(Icons.access_time)),
          onTap: () async {
            final parts = controllers[i].text.split(':');
            final t = await showTimePicker(context: ctx, initialTime: TimeOfDay(hour: int.tryParse(parts[0]) ?? 0, minute: int.tryParse(parts[1]) ?? 0));
            if (t != null) controllers[i].text = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
          },
        )),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
        FilledButton(onPressed: () {
          final values = controllers.map((c) => c.text).toList();
          final mins = values.map((v) {
            final p = v.split(':'); return int.parse(p[0]) * 60 + int.parse(p[1]);
          }).toList();
          if (List.generate(4, (i) => mins[i] < mins[i + 1]).contains(false)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Urutan waktu harus berurutan dari Subuh sampai Isya.')));
            return;
          }
          Navigator.pop(ctx, PrayerSchedule(date: date, fajr: values[0], dhuhr: values[1], asr: values[2], maghrib: values[3], isha: values[4]));
        }, child: const Text('Simpan')),
      ],
    ));
    for (final c in controllers) { c.dispose(); }
    if (result != null) { await widget.repo.saveSchedule(result); if (mounted) setState(() {}); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<PrayerSchedule>>(
      future: widget.repo.getSchedules(),
      builder: (context, snap) {
        final rows = snap.data ?? [];
        if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
        return rows.isEmpty ? const Center(child: Text('Belum ada jadwal. Tekan + untuk menambahkan.')) :
          ListView.builder(padding: const EdgeInsets.all(12), itemCount: rows.length, itemBuilder: (ctx, i) {
            final s = rows[i];
            return Card(child: ListTile(
              title: Text(s.date),
              subtitle: Text('Subuh ${s.fajr} • Dzuhur ${s.dhuhr} • Ashar ${s.asr}\\nMaghrib ${s.maghrib} • Isya ${s.isha}'),
              isThreeLine: true,
              onTap: () => _edit(s),
              trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () async {
                if (s.id != null) await widget.repo.deleteSchedule(s.id!);
                if (mounted) setState(() {});
              }),
            ));
          });
      },
    ),
    floatingActionButton: FloatingActionButton(onPressed: () => _edit(), child: const Icon(Icons.add)),
  );
}

class AttendancePage extends StatefulWidget {
  final SajadahRepository repo;
  const AttendancePage({super.key, required this.repo});
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}
class _AttendancePageState extends State<AttendancePage> {
  final values = <String, String>{};
  final note = TextEditingController();
  DateTime date = DateTime.now();

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final items = await widget.repo.getAttendance(date: dateKey(date));
    values.clear();
    for (final a in items) { values[a.prayer] = a.status; }
    if (mounted) setState(() {});
  }
  @override
  void dispose() { note.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    ListTile(title: const Text('Tanggal presensi'), subtitle: Text(dateKey(date)),
      trailing: IconButton(icon: const Icon(Icons.calendar_month), onPressed: () async {
        final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2100));
        if (d != null) { date = d; await _load(); }
      })),
    const SizedBox(height: 8),
    ...prayers.map((p) => Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(p, style: Theme.of(context).textTheme.titleMedium),
        DropdownButtonFormField<String>(
          initialValue: values[p],
          decoration: const InputDecoration(labelText: 'Status'),
          items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() { if (v != null) values[p] = v; }),
        ),
      ],
    )))),
    TextField(controller: note, decoration: const InputDecoration(labelText: 'Catatan (opsional)')),
    const SizedBox(height: 16),
    FilledButton.icon(onPressed: () async {
      for (final p in prayers) {
        final status = values[p];
        if (status != null) {
          await widget.repo.saveAttendance(PrayerAttendance(date: dateKey(date), prayer: p, status: status, note: note.text));
        }
      }
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Presensi berhasil disimpan.')));
    }, icon: const Icon(Icons.save), label: const Text('Simpan presensi')),
  ]);
}

class HistoryPage extends StatefulWidget {
  final SajadahRepository repo;
  const HistoryPage({super.key, required this.repo});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}
class _HistoryPageState extends State<HistoryPage> {
  String filter = 'Semua';
  @override
  Widget build(BuildContext context) => FutureBuilder<List<PrayerAttendance>>(
    future: widget.repo.getAttendance(),
    builder: (context, snap) {
      final all = snap.data ?? [];
      final shown = filter == 'Semua' ? all : all.where((a) => a.status == filter).toList();
      return Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: DropdownButtonFormField<String>(
          initialValue: filter, decoration: const InputDecoration(labelText: 'Filter status'),
          items: ['Semua', ...statuses].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() => filter = v ?? 'Semua'),
        )),
        Expanded(child: shown.isEmpty ? const Center(child: Text('Belum ada riwayat presensi.')) :
          ListView.builder(itemCount: shown.length, itemBuilder: (ctx, i) {
            final a = shown[i];
            return ListTile(title: Text('${a.prayer} — ${a.status}'), subtitle: Text(a.date),
              trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () async {
                if (a.id != null) await widget.repo.deleteAttendance(a.id!);
                if (mounted) setState(() {});
              }));
          })),
      ]);
    },
  );
}

class SettingsPage extends StatelessWidget {
  final String name;
  final bool dark;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<String> onNameChanged;
  const SettingsPage({super.key, required this.name, required this.dark, required this.onThemeChanged, required this.onNameChanged});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    Text('Pengaturan', style: Theme.of(context).textTheme.headlineSmall),
    const SizedBox(height: 12),
    ListTile(title: const Text('Nama pengguna'), subtitle: Text(name), trailing: const Icon(Icons.edit),
      onTap: () async {
        final c = TextEditingController(text: name);
        final value = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
          title: const Text('Ubah nama'),
          content: TextField(controller: c, autofocus: true, decoration: const InputDecoration(labelText: 'Nama')),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: const Text('Simpan'))],
        ));
        c.dispose();
        if (value != null && value.isNotEmpty) onNameChanged(value);
      }),
    SwitchListTile(title: const Text('Tema gelap'), value: dark, onChanged: onThemeChanged),
    const ListTile(title: Text('Tentang SajadahKu'), subtitle: Text('Aplikasi jadwal dan presensi sholat offline.')),
  ]);
}
