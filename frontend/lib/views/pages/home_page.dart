part of 'pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0, // Remove top appbar space
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Hello, Ivone!",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("Your pets miss you, check it now",
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).go('/profile');
                  },
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.pink[100],
                    child: Icon(Icons.person, color: Colors.red[900]),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            // Premium Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[300],
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      child: Text("Go premium!\nGet unlimited access to all features",
                          style: TextStyle(color: Colors.white))),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Subscribe"),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Upcoming Schedules
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upcoming schedules",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text("View all",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),

            // Schedule Cards
            _scheduleCard("Vaccination", "Today, 2:00 PM - Molly", Icons.medical_services, Colors.red),
            _scheduleCard("Grooming", "Tomorrow, 1:00 PM - Henry", Icons.cut, Colors.blue),

            const SizedBox(height: 20),
            const Text("My pets",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            // Filter buttons
            Row(
              children: [
                _chip("All", isSelected: true),
                _chip("Cat"),
                _chip("Dog"),
              ],
            ),
            const SizedBox(height: 10),

            // Pet Cards
            _petCard("Molly", "Golden Retriever", "Female", "2 years",
                "assets/dog.png"),
            _petCard("Henry", "Persian Cat", "Male", "2 years",
                "assets/cat.png", isLast: true),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.pets), label: "My Pet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy), label: "Ask AI"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital), label: "Need Vet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "My Expenses"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _scheduleCard(String title, String time, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
      ),
    );
  }

  Widget _chip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {},
        selectedColor: Colors.blue[100],
      ),
    );
  }

  Widget _petCard(String name, String breed, String gender, String age,
      String imagePath, {bool isLast = false}) {
    return Card(
      margin: EdgeInsets.only(bottom: isLast ? 80 : 12),
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(breed),
            Row(
              children: [
                Icon(gender == "Female" ? Icons.female : Icons.male,
                    size: 14, color: gender == "Female" ? Colors.pink : Colors.blue),
                const SizedBox(width: 4),
                Text(gender),
                const SizedBox(width: 10),
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(age),
              ],
            )
          ],
        ),
      ),
    );
  }
}
