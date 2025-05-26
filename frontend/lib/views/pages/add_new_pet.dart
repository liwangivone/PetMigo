part of 'pages.dart';

class ChoosePetPage extends StatefulWidget {
  const ChoosePetPage({super.key});

  @override
  State<ChoosePetPage> createState() => _ChoosePetPageState();
}

class _ChoosePetPageState extends State<ChoosePetPage> {
  String? selectedPet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0, // Remove top space
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const Text(
              "Select your new pet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPetOption("Cat", "assets/images/dog.png"),
                _buildPetOption("Dog", "assets/images/cat.png"),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedPet != null ? () {
                  // TODO: Navigate or save selection
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You selected: $selectedPet")),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  disabledBackgroundColor: Colors.orange.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetOption(String petType, String imagePath) {
    final isSelected = selectedPet == petType;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPet = petType;
        });
      },
      child: Container(
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.orange, width: 3) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80),
            const SizedBox(height: 10),
            Text(
              petType,
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
