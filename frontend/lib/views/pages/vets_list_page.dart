part of 'pages.dart';

class VetListPage extends StatelessWidget {
  const VetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<VetModel> vets = [
      VetModel(
        name: 'drh. Tommy Woofhart',
        clinic: 'Dokter Hewan Di Pet Clinic (MPC)',
        experience: '4 Tahun',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      VetModel(
        name: 'drh. Kevin Prasetya',
        clinic: 'Dokter Hewan Di Doc Pet Clinic',
        experience: '4 Tahun',
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Vets')),
      body: ListView.builder(
        itemCount: vets.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final vet = vets[index];
          return GestureDetector(
            onTap: () => context.push('/detail-vet', extra: vet),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(vet.imageUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(vet.clinic),
                          Text('Pengalaman: ${vet.experience}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}