part of 'pages.dart';

class PetScheduleInputView extends StatefulWidget {
  const PetScheduleInputView({super.key});

  @override
  State<PetScheduleInputView> createState() => _PetScheduleInputViewState();
}

class PetScheduleInputData {
  String? petId;
  String? petName;
  PetScheduleCategory? category;
  String? description;
  DateTime? date;
  int? expense;

  bool get isValid =>
      petId != null &&
      petName != null &&
      category != null &&
      description != null &&
      description!.isNotEmpty &&
      date != null &&
      expense != null;
}

class _PetScheduleInputViewState extends State<PetScheduleInputView> {
  final schedules = <PetScheduleInputData>[PetScheduleInputData()];
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetBloc(PetService())..add(GetPetData()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.go('/myexpenses'),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Pet Schedule', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        body: SafeArea(
          child: BlocBuilder<PetBloc, PetState>(
            builder: (context, state) {
              if (state is PetLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PetError) {
                return Center(child: Text(state.message));
              }
              if (state is PetLoaded) {
                return _buildContent(state.pets);
              }
              return const Center(child: Text('No pet data available'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<Pet> pets) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < schedules.length; i++) ...[
                  if (i == 0) _scheduleHeader(),
                  _form(i, pets),
                  const SizedBox(height: 24),
                  if (i != schedules.length - 1)
                    const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 12),
                Center(child: _bottomButtons()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scheduleHeader() => Column(
    children: [
      Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const CircleAvatar(radius: 55, backgroundColor: Colors.black12),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.calendar_today, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 36),
    ],
  );

  Widget _form(int idx, List<Pet> pets) {
    final s = schedules[idx];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Pet Name'),
        DropdownButtonFormField<String>(
          value: s.petId,
          items: pets.map((pet) => DropdownMenuItem(
            value: pet.id,
            child: Text(pet.name),
          )).toList(),
          onChanged: (v) {
            final selectedPet = pets.firstWhere((pet) => pet.id == v);
            setState(() {
              s.petId = v;
              s.petName = selectedPet.name;
            });
          },
          decoration: _hint('Select pet'),
        ),
        const SizedBox(height: 20),

        _label('Category'),
        DropdownButtonFormField<PetScheduleCategory>(
          value: s.category,
          items: PetScheduleCategory.values.map((cat) => DropdownMenuItem(
            value: cat,
            child: Text(cat.name),
          )).toList(),
          onChanged: (v) => setState(() => s.category = v),
          decoration: _hint('Select category'),
        ),
        const SizedBox(height: 20),

        _label('Description'),
        TextField(
          onChanged: (v) => setState(() => s.description = v),
          decoration: _hint('e.g. Annual rabies shot'),
        ),
        const SizedBox(height: 20),

        _label('Expense (IDR)'),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() => s.expense = int.tryParse(v)),
          decoration: _hint('e.g. 200000'),
        ),
        const SizedBox(height: 20),

        _label('Date'),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (pickedDate != null) {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(DateTime.now()),
              );
              if (pickedTime != null) {
                final combined = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
                setState(() => s.date = combined);
              }
            }
          },
          child: InputDecorator(
            decoration: _hint('Select Date'),
            child: Text(
              s.date == null
                  ? 'Select Date'
                  : '${s.date!.day.toString().padLeft(2, '0')} ${_month(s.date!.month)} ${s.date!.year} - ${s.date!.hour.toString().padLeft(2, '0')}:${s.date!.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: s.date == null ? Colors.grey : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomButtons() {
    final isValid = schedules.every((e) => e.isValid);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: schedules.length >= 3
              ? null
              : () => setState(() => schedules.add(PetScheduleInputData())),
          icon: const Icon(Icons.add, color: Colors.orange),
          label: const Text('Add more', style: TextStyle(color: Colors.orange)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFC9C9C9)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            minimumSize: const Size(160, 48),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: isValid && !isSaving ? _save : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid ? Colors.orange : Colors.orange.withAlpha((255 * 0.4).round()),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            minimumSize: const Size(120, 48),
          ),
          child: isSaving
              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Done'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    setState(() => isSaving = true);

    for (final s in schedules) {
      final petSchedule = PetSchedule(
        id: '',
        category: s.category!,
        expense: s.expense!,
        description: s.description!,
        date: s.date!,
        petId: s.petId!,
        petName: s.petName!,
        petType: '',
      );
      context.read<PetScheduleBloc>().add(CreatePetSchedule(s.petId!, petSchedule));
    }

    await Future.delayed(const Duration(seconds: 1));
    setState(() => isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedules submitted successfully')),
    );
    context.go('/myexpenses');
  }

  InputDecoration _hint(String hint) => InputDecoration(
    hintText: hint,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  String _month(int m) => [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December']
  [m - 1];
}
