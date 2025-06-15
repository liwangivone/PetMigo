part of 'pages.dart';
// ─────────────────────────────────────────────────────────────────────────────
//  PetDetailPage – always reloads fresh data when opened and after edit        
// ─────────────────────────────────────────────────────────────────────────────
class PetDetailPage extends StatefulWidget {
  final Pet pet; // initial snapshot passed from previous screen
  const PetDetailPage({super.key, required this.pet});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  late Pet _pet; // mutable copy so we can update after editing
  bool _showAllSchedules = false;
  bool _showAllFiles = false;

  @override
  void initState() {
    super.initState();
    _pet = widget.pet;
    _loadSchedules(); // fetch latest data the moment the page is created
  }

  // helper to dispatch the schedule‑loading event
  void _loadSchedules() {
    context.read<PetScheduleBloc>().add(LoadPetSchedulesByPetId(_pet.id));
  }

  // navigate to edit page and await the (potentially) updated Pet
  Future<void> _gotoEdit() async {
    final Pet? updated = await Navigator.push<Pet>(
      context,
      MaterialPageRoute(builder: (_) => PetEditPage(pet: _pet)),
    );

    if (updated != null) {
      setState(() => _pet = updated); // refresh local pet data
      _loadSchedules(); // schedules might depend on pet changes
    }
  }

  @override
  Widget build(BuildContext context) {
    final imgAsset = _pet.type.toLowerCase() == 'cat'
        ? 'assets/images/cat.png'
        : 'assets/images/dog.png';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/dashboard'),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadSchedules(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _photoCard(imgAsset),
              const SizedBox(height: 12),
              _infoCard(children: [
                _infoRow("Name", _pet.name),
                _infoRow("Type", _pet.type),
                _infoRow("Gender", _pet.gender),
                _infoRow("Color", _pet.color ?? '-'),
                _infoRow("Weight", "${_pet.weight} Kg"),
                _infoRow(
                  "Birthdate",
                  DateFormat('d MMM yyyy').format(_pet.birthdate),
                ),
              ]),
              const SizedBox(height: 12),

              _sectionHeader(
                context,
                title: "Schedules",
                onViewAll: () => setState(() => _showAllSchedules = !_showAllSchedules),
                isExpanded: _showAllSchedules,
              ),
              BlocBuilder<PetScheduleBloc, PetScheduleState>(
                builder: (context, state) {
                  if (state is PetScheduleLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PetScheduleLoaded) {
                    final upcoming = state.schedules
                        .where((s) => s.petId == _pet.id && s.date.isAfter(DateTime.now()))
                        .toList()
                      ..sort((a, b) => a.date.compareTo(b.date));

                    if (upcoming.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("No upcoming schedules."),
                      );
                    }

                    final displayed =
                        _showAllSchedules ? upcoming : upcoming.take(3).toList();

                    return Column(
                      children: displayed.map(_scheduleTileFromModel).toList(),
                    );
                  } else if (state is PetScheduleError) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text("Error: ${state.message}",
                          style: const TextStyle(color: Colors.red)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 12),

              _sectionHeader(
                context,
                title: "Files",
                onViewAll: () => setState(() => _showAllFiles = !_showAllFiles),
                isExpanded: _showAllFiles,
              ),
              _showAllFiles
                  ? ListTile(
                      leading:
                          const Icon(Icons.insert_drive_file, color: Colors.grey),
                      title: const Text("Vaccination record.pdf"),
                      subtitle: const Text("120 KB • PDF"),
                      onTap: () {/* open document */},
                    )
                  : ListTile(
                      leading:
                          const Icon(Icons.insert_drive_file, color: Colors.grey),
                      title: const Text("1 document"),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () {/* add file */},
                      ),
                    ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /*──────────────────────────── helper widgets ────────────────────────────*/

  Widget _photoCard(String imgAsset) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(imgAsset, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            ListTile(
              title: Text(_pet.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${_pet.type} (${_pet.breed ?? '-'})"),
              trailing: TextButton(
                onPressed: _gotoEdit,
                child: const Text("Edit"),
              ),
            ),
          ],
        ),
      );

  Widget _infoCard({required List<Widget> children}) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: children),
        ),
      );

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _sectionHeader(BuildContext ctx,
          {required String title, required VoidCallback onViewAll, required bool isExpanded}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: onViewAll,
            child: Text(isExpanded ? "Hide" : "View all"),
          ),
        ],
      );

  Widget _scheduleTileFromModel(PetSchedule s) {
    final label = _capitalize(s.category.name);

    IconData icon;
    Color color;
    switch (label) {
      case "Vaccination":
        icon = Icons.medical_services;
        color = Colors.red;
        break;
      case "Grooming":
        icon = Icons.cut;
        color = Colors.blue;
        break;
      case "Food":
        icon = Icons.restaurant;
        color = Colors.green;
        break;
      case "Toys":
        icon = Icons.toys;
        color = Colors.orange;
        break;
      case "Snack":
        icon = Icons.fastfood;
        color = Colors.purple;
        break;
      default:
        icon = Icons.event_note;
        color = Colors.grey;
        break;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final schedDay = DateTime(s.date.year, s.date.month, s.date.day);

    String dateLabel;
    if (schedDay == today) {
      dateLabel = "Today, ${DateFormat('h:mm a').format(s.date)}";
    } else if (schedDay == tomorrow) {
      dateLabel = "Tomorrow, ${DateFormat('h:mm a').format(s.date)}";
    } else {
      dateLabel = DateFormat('EEEE, d MMM').format(s.date);
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(label),
      subtitle: Text(dateLabel),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}