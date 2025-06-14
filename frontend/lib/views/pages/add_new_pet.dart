part of 'pages.dart';
class ChoosePetPage extends StatefulWidget {
  const ChoosePetPage({Key? key}) : super(key: key);

  @override
  State<ChoosePetPage> createState() => _ChoosePetPageState();
}

class _ChoosePetPageState extends State<ChoosePetPage> {
  String? _selectedPet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const Text("Select your new pet",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            // Opsi hewan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPetOption("CAT", "assets/images/cat.png"),
                _buildPetOption("DOG", "assets/images/dog.png"),
              ],
            ),
            const Spacer(),

            // Tombol Confirm
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPet == null ? null : _goToDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  disabledBackgroundColor: Colors.orange.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetOption(String petType, String image) {
    final selected = _selectedPet == petType;
    return GestureDetector(
      onTap: () => setState(() => _selectedPet = petType),
      child: Container(
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(20),
          border: selected ? Border.all(color: Colors.orange, width: 3) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 80),
            const SizedBox(height: 10),
            Text(petType, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Future<void> _goToDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pettype', _selectedPet!);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PetDetailsPage(petType: _selectedPet!)),
    );
  }
}

// ───────────────────────────────── PetDetailsPage
class PetDetailsPage extends StatefulWidget {
  final String petType;
  const PetDetailsPage({Key? key, required this.petType}) : super(key: key);

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

// ───────────────────────────────── PetInputData
class PetInputData {
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  String? gender;
  DateTime? birthdate;

  bool get isValid =>
      nameController.text.isNotEmpty &&
      breedController.text.isNotEmpty &&
      gender != null &&
      birthdate != null;
}

// ───────────────────────────────── Page State
class _PetDetailsPageState extends State<PetDetailsPage> {
  final pets = <PetInputData>[PetInputData()];
  int petsSucceeded = 0; // hitung sukses

  @override
  Widget build(BuildContext context) {
    return BlocListener<PetBloc, PetState>(
      listener: (context, state) {
        // ——— SUKSES ———
        if (state is PetSuccess) {
          petsSucceeded++;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));

          if (petsSucceeded == pets.length) {
            context.go('/dashboard');
          }
        }
        // ——— ERROR ———
        else if (state is PetError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
          context.go('/choosepet');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Pet details',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    children: [
                      for (int i = 0; i < pets.length; i++) _form(i),
                      const SizedBox(height: 16),
                      _bottomButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────── Form
  Widget _form(int idx) {
    final p = pets[idx];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (idx == 0) ...[
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
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
        ],
        _label('Name'),
        TextField(
          controller: p.nameController,
          onChanged: (_) => setState(() {}),
          decoration: _hint('Molly'),
        ),
        const SizedBox(height: 24),
        _label('Gender'),
        DropdownButtonFormField<String>(
          value: p.gender,
          items: const [
            DropdownMenuItem(value: 'MALE', child: Text('MALE')),
            DropdownMenuItem(value: 'FEMALE', child: Text('FEMALE')),
          ],
          onChanged: (v) => setState(() => p.gender = v),
          decoration: _hint('FEMALE'),
        ),
        const SizedBox(height: 24),
        _label('Birthdate'),
        InkWell(
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: DateTime(2020),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (d != null) setState(() => p.birthdate = d);
          },
          child: InputDecorator(
            decoration:
                const InputDecoration(border: UnderlineInputBorder(), isDense: true),
            child: Text(
              p.birthdate == null
                  ? '15 November 2020'
                  : '${p.birthdate!.day.toString().padLeft(2, '0')} ${_month(p.birthdate!.month)} ${p.birthdate!.year}',
              style: TextStyle(
                  color: p.birthdate == null ? Colors.grey : Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _label('Breed'),
        TextField(
          controller: p.breedController,
          onChanged: (_) => setState(() {}),
          decoration: _hint('Pomeranian'),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ───────────────────────────────── Bottom Buttons
  Widget _bottomButtons() {
    final valid = pets.every((e) => e.isValid);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 160,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: pets.length >= 3
                ? null
                : () => setState(() => pets.add(PetInputData())),
            icon: const Icon(Icons.add, color: Colors.orange),
            label:
                const Text('Add more pet', style: TextStyle(color: Colors.orange)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFC9C9C9)),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          height: 48,
          child: ElevatedButton(
            onPressed: valid ? _save : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  valid ? Colors.orange : Colors.orange.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────── Save
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pettype', widget.petType);

    final userId = prefs.getString('userid') ?? '';
    final petType = prefs.getString('pettype') ?? widget.petType;

    if (userId.isEmpty || petType.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('UserID atau pet type kosong')));
      return;
    }

    petsSucceeded = 0; // reset hitungan sebelum submit
    for (final p in pets) {
      final pet = Pet(
        id: '',
        name: p.nameController.text,
        gender: p.gender!.toUpperCase(),
        birthdate: p.birthdate!,
        type: petType,
        breed: p.breedController.text,
      );
      context.read<PetBloc>().add(CreatePet(userId: userId, pet: pet));
    }
  }

  // ───────────────────────────────── Helpers
  InputDecoration _hint(String hint) => InputDecoration(hintText: hint, isDense: true);
  Widget _label(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  String _month(int m) => [
        'January','February','March','April','May','June',
        'July','August','September','October','November','December'
      ][m - 1];
}
