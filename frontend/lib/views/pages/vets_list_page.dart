part of 'pages.dart';

class VetListPage extends StatefulWidget {
  const VetListPage({super.key});

  @override
  State<VetListPage> createState() => _VetListPageState();
}

class _VetListPageState extends State<VetListPage> {
  bool _showAllVets = false;
  bool _showAllClinics = false;

  @override
  void initState() {
    super.initState();
    context.read<VetBloc>().add(const FetchAllVets());
    context.read<ClinicBloc>().add(FetchAllClinics());
  }

  // ──────────────────────── VET CARD ────────────────────────
  Widget _vetCard(VetModel v) {
    final clinicName = v.clinicName;
    final specialization = (v.specialization.trim().isEmpty ||
            v.specialization.toLowerCase() == 'string' ||
            v.specialization.toLowerCase() == 'null')
        ? 'Dokter Hewan'
        : v.specialization;

    return GestureDetector(
      onTap: () => context.push('/detail-vet', extra: v),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            _image(v.imageUrl),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleText(v.name),
                  const SizedBox(height: 4),
                  _subText(clinicName.isEmpty
                      ? specialization
                      : '$specialization di $clinicName'),
                  const SizedBox(height: 4),
                  _subText('Pengalaman: ${v.experienceYears} tahun'),
                  const SizedBox(height: 4),
                  _subText('Status: ${v.status.name}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────── CLINIC CARD (tidak bisa ditekan) ────────────────────────
  Widget _clinicCard(ClinicModel c) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            _image(c.imageUrl),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleText(c.name),
                  const SizedBox(height: 4),
                  _subText(c.location),
                  const SizedBox(height: 4),
                  _subText('OPEN: ${c.openingHours}'),
                ],
              ),
            ),
          ],
        ),
      );

  // ──────────────────────── SECTION BUILDER ────────────────────────
  Widget _section({
    required String title,
    required String subtitle,
    required List<Widget> children,
    required bool showAll,
    required VoidCallback onToggle,
  }) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleText(title, big: true),
            const SizedBox(height: 4),
            _subText(subtitle),
            const SizedBox(height: 16),
            ...children,
            GestureDetector(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  showAll ? 'View less' : 'View all',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF007BFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  Widget _image(String url, {double size = 56}) {
    final safeUrl = url.trim().isEmpty ? 'assets/images/cat.png' : url;
    final isAsset = !safeUrl.startsWith('http');
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: isAsset
              ? AssetImage(safeUrl)
              : NetworkImage(safeUrl) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _titleText(String txt, {bool big = false}) => Text(
        txt,
        style: TextStyle(
          fontSize: big ? 20 : 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );

  Widget _subText(String txt) => Text(
        txt,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );

  // ──────────────────────── BUILD ────────────────────────
  @override
  Widget build(BuildContext context) {
    final vetSection = BlocBuilder<VetBloc, VetState>(
      builder: (context, vetState) {
        if (vetState is VetLoading) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (vetState is VetError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Text(vetState.message, style: const TextStyle(color: Colors.red)),
          );
        }
        if (vetState is VetListLoaded) {
          final raw = vetState.vets;
          final display =
              _showAllVets || raw.length <= 2 ? raw : raw.take(2).toList();

          return _section(
            title: 'Nearby Vets',
            subtitle: 'Vets near you with trusted experience',
            children: display.map(_vetCard).toList(),
            showAll: _showAllVets,
            onToggle: () => setState(() => _showAllVets = !_showAllVets),
          );
        }
        return const SizedBox.shrink();
      },
    );

    final clinicSection = BlocBuilder<ClinicBloc, ClinicState>(
      builder: (context, state) {
        if (state is ClinicLoading) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ClinicError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Text(state.message, style: const TextStyle(color: Colors.red)),
          );
        }
        if (state is ClinicListLoaded) {
          final raw = state.list;
          final display =
              _showAllClinics || raw.length <= 2 ? raw : raw.take(2).toList();

          return _section(
            title: 'Nearby Clinics',
            subtitle: 'Trusted clinics with complete service hours',
            children: display.map(_clinicCard).toList(),
            showAll: _showAllClinics,
            onToggle: () =>
                setState(() => _showAllClinics = !_showAllClinics),
          );
        }
        return const SizedBox.shrink();
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: const BottomNavbar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            clinicSection,
            vetSection,
          ],
        ),
      ),
    );
  }
}
