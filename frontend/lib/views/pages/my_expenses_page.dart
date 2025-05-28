part of 'pages.dart';

class MyExpensesPage extends StatefulWidget {
  const MyExpensesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyExpensesPageState createState() => _MyExpensesPageState();
}

class _MyExpensesPageState extends State<MyExpensesPage> {
  @override
  void initState() {
    context.read<ExpensesBloc>().add(LoadExpenses());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExpensesBloc, ExpensesState>(
        builder: (context, state) {
          if (state is ExpensesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExpensesLoaded) {
            final expenses = state.expenses;

            // Total
            final total = expenses.fold<int>(0, (sum, e) => sum + e.amount);

            // Kelompokkan berdasarkan kategori
            final dataMap = <String, double>{};
            for (var e in expenses) {
              dataMap[e.category] = (dataMap[e.category] ?? 0) + e.amount;
            }

            // Kelompokkan berdasarkan tanggal
            final grouped = <String, List<Expense>>{};
            for (var e in expenses) {
              grouped.putIfAbsent(e.date, () => []).add(e);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("My Expenses", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Filter Buttons
                  Row(
                    children: [
                      _chip("All", true),
                      _chip("Cat", false),
                      _chip("Dog", false),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Pie Chart Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Rp $total", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        PieChart(
                          dataMap: dataMap.map((k, v) => MapEntry(k, v.toDouble())),
                          colorList: [Colors.blue[200]!, Colors.red[200]!],
                          chartType: ChartType.disc,
                          chartRadius: 130,
                          legendOptions: const LegendOptions(showLegends: true),
                          chartValuesOptions: const ChartValuesOptions(showChartValues: false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // List Per Tanggal
                  Expanded(
                    child: ListView(
                      children: grouped.entries.map((entry) {
                        final date = entry.key;
                        final items = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDate(date), style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const Text("View all", style: TextStyle(color: Colors.blue)),
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
        onSelected: (_) {},
        selectedColor: Colors.blue[100],
      ),
    );
  }

  Widget _expenseTile(Expense e) {
    IconData icon = e.category == "Grooming" ? Icons.cut : Icons.medical_services;
    Color color = e.category == "Grooming" ? Colors.blue : Colors.red;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(e.title),
        subtitle: Text("Rp ${e.amount} - ${e.petName}\n${e.time}"),
        isThreeLine: true,
      ),
    );
  }

  String _formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
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
