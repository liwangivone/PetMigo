part of 'pages.dart';

class MyExpensesPage extends StatefulWidget {
  const MyExpensesPage({super.key});

  @override
  _MyExpensesPageState createState() => _MyExpensesPageState();
}

class _MyExpensesPageState extends State<MyExpensesPage> {
  String selectedFilter = "All";

  final Map<String, Color> categoryColors = {
    "Vaccination": Colors.red,
    "Grooming": Colors.blue,
    "Food": Colors.green,
    "Toys": Colors.orange,
    "Snack": Colors.purple,
    "Others": Colors.grey,
  };

  final List<String> orderedCategories =
      PetScheduleCategory.values.map((e) => e.name).toList();

  @override
  void initState() {
    super.initState();
    context.read<PetScheduleBloc>().add(LoadPetSchedules());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PetScheduleBloc, PetScheduleState>(
        builder: (context, state) {
          if (state is PetScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PetScheduleLoaded) {
            final allSchedules = state.schedules;
            final expenses = allSchedules.where((e) => e.expense > 0).toList();

            final filteredExpenses = selectedFilter == "All"
                ? expenses
                : expenses
                    .where((e) =>
                        e.petType.toUpperCase() == selectedFilter.toUpperCase())
                    .toList();

            final total = filteredExpenses.fold<int>(0, (sum, e) => sum + e.expense);

            final Map<String, double> fullDataMap = {
              for (var cat in orderedCategories) cat: 0,
            };

            for (var e in filteredExpenses) {
              final key = e.category.name;
              fullDataMap[key] = (fullDataMap[key] ?? 0) + e.expense;
            }

            final filteredDataMap = Map.fromEntries(
              fullDataMap.entries.where((entry) => entry.value > 0),
            );

            final colorList = filteredDataMap.keys
                .map((key) => categoryColors[key] ?? Colors.grey)
                .toList();

            final Map<DateTime, List<PetSchedule>> grouped = {};
            for (var e in filteredExpenses) {
              final date = DateTime(e.date.year, e.date.month, e.date.day);
              grouped.putIfAbsent(date, () => []).add(e);
            }

            final sortedEntries = grouped.entries.toList()
              ..sort((a, b) => b.key.compareTo(a.key));

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("My Expenses",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _chip("All", selectedFilter == "All"),
                      _chip("CAT", selectedFilter == "CAT"),
                      _chip("DOG", selectedFilter == "DOG"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Rp $total",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            FloatingActionButton(
                              onPressed: () {},
                              backgroundColor: Colors.blue,
                              mini: true,
                              child: const Icon(Icons.add),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (filteredDataMap.isNotEmpty)
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              dataMap: filteredDataMap,
                              colorList: colorList,
                              chartType: ChartType.disc,
                              legendOptions:
                                  const LegendOptions(showLegends: true),
                              chartValuesOptions:
                                  const ChartValuesOptions(showChartValues: false),
                            ),
                          )
                        else
                          const Text("Tidak ada data pengeluaran."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: sortedEntries.map((entry) {
                        final date = entry.key;
                        final items = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDate(date),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const Text("View all",
                                      style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ),
                            ...items.map((e) => _expenseTile(e)).toList(),
                          ],
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            );
          }

          return const Center(child: Text("Unknown error"));
        },
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 3),
    );
  }

  Widget _chip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedFilter = label;
          });
        },
        selectedColor: Colors.blue[100],
      ),
    );
  }

  Widget _expenseTile(PetSchedule e) {
    IconData icon;
    Color color;

    switch (e.category.name) {
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
      case "Others":
      default:
        icon = Icons.event_note;
        color = Colors.grey;
        break;
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(e.description),
        subtitle: Text("Rp ${e.expense} - ${e.petName}\n${DateFormat.Hm().format(e.date)}"),
        isThreeLine: true,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${_namaHari(date.weekday)}, ${date.day} ${_bulan(date.month)} ${date.year}";
  }

  String _namaHari(int weekday) {
    const days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
    return days[weekday - 1];
  }

  String _bulan(int month) {
    const months = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return months[month - 1];
  }
}
