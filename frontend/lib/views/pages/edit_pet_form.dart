
part of 'pages.dart';

class PetEditPage extends StatefulWidget {
  final Pet pet;
  const PetEditPage({super.key, required this.pet});

  @override
  State<PetEditPage> createState() => _PetEditPageState();
}

class _PetEditPageState extends State<PetEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late DateTime _birthDate;
  late String _selectedGender;
  late String _selectedSpecies;
  final List<Color> _selectedColors = [Colors.brown[100]!, Colors.white];

  @override
  void initState() {
    super.initState();
    final pet = widget.pet;
    _nameController = TextEditingController(text: pet.name);
    _breedController = TextEditingController(text: pet.breed ?? '');
    _birthDate = pet.birthdate;
    _selectedGender = pet.gender;
    _selectedSpecies = pet.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  void _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _editPet() {
    final updatedPet = Pet(
      id: widget.pet.id,
      name: _nameController.text.trim(),
      breed: _breedController.text.trim(),
      gender: _selectedGender,
      type: _selectedSpecies,
      birthdate: _birthDate,
      weight: widget.pet.weight,
      color: widget.pet.color,
      petSchedules: widget.pet.petSchedules,
    );
    context.read<PetBloc>().add(UpdatePet(updatedPet));
    Navigator.pop(context, updatedPet); // return the Pet, not just a flag
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this pet?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context); // close dialog
              context.read<PetBloc>().add(DeletePet(widget.pet.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = _selectedSpecies == 'DOG'
        ? 'assets/images/dog.png'
        : 'assets/images/cat.png';

    return BlocListener<PetBloc, PetState>(
      listener: (context, state) {
        if (state is PetDeleted) {
          context.go('/dashboard');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Edit pet profile', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: _editPet,
              child:
                  const Text('Save', style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(profileImage,
                            width: 200, height: 200, fit: BoxFit.cover),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black.withOpacity(0.6),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabelField('Name', _nameController),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Gender',
                        value: _selectedGender,
                        options: const ['MALE', 'FEMALE'],
                        displayMap: const {'MALE': 'Male', 'FEMALE': 'Female'},
                        onChanged: (val) => setState(() => _selectedGender = val),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Species',
                        value: _selectedSpecies,
                        options: const ['DOG', 'CAT'],
                        displayMap: const {'DOG': 'Dog', 'CAT': 'Cat'},
                        onChanged: (val) => setState(() => _selectedSpecies = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabelField('Breed', _breedController),
                const SizedBox(height: 16),
                _buildColorSection(),
                const SizedBox(height: 16),
                _buildBirthdatePicker(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _confirmDelete,
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.delete, color: Colors.white),
          label: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  /*──────────────────────────── form widgets ─────────────────────────────*/

  Widget _buildLabelField(String label, TextEditingController controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      );

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required Map<String, String> displayMap,
    required Function(String) onChanged,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: options
                  .map((e) => DropdownMenuItem(value: e, child: Text(displayMap[e] ?? e)))
                  .toList(),
              onChanged: (val) => onChanged(val!),
            ),
          ),
        ],
      );

  Widget _buildColorSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Color',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              ..._selectedColors.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(backgroundColor: c, radius: 14),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildBirthdatePicker() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Birthdate',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 4),
          InkWell(
            onTap: _pickBirthDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd/MM/yy').format(_birthDate)),
                ],
              ),
            ),
          ),
        ],
      );
}
