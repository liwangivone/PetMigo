part of 'pages.dart';

class VetRegisterScreen extends StatelessWidget {
  const VetRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final specializationController = TextEditingController();
    final experienceController = TextEditingController();
    final overviewController = TextEditingController();
    final scheduleController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    final ValueNotifier<bool> agreed = ValueNotifier(false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<VetBloc, VetState>(
          listener: (context, state) {
            if (state is VetLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state is VetAuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Akun vet berhasil dibuat!')),
              );
              context.go('/vet/login');
            }

            if (state is VetError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Create your vet account',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Image.asset(
                      'assets/images/petmigo_logo.png',
                      height: 180,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _input("Full name", nameController, validator: (val) {
                    if (val == null || val.trim().length < 2) return 'Minimal 2 karakter';
                    return null;
                  }),
                  _input("Email", emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val != null && val.contains('@') ? null : 'Email tidak valid'),
                  _input("Password", passwordController,
                      obscure: true,
                      helper: "Password minimal 6 karakter",
                      validator: (val) => val != null && val.length >= 6 ? null : 'Minimal 6 karakter'),
                  _input("Specialization", specializationController),
                  _input(
                    "Experience (years)",
                    experienceController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Wajib diisi';
                      final parsed = int.tryParse(val);
                      if (parsed == null || parsed < 0) return 'Harus berupa angka';
                      return null;
                    },
                  ),
                  _input(
                    "Schedule",
                    scheduleController,
                    hint: "Contoh: 12:00 - 20:00 Senin - Jumat",
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: agreed,
                    builder: (_, value, __) => Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: value,
                              onChanged: (val) => agreed.value = val ?? false,
                            ),
                            const Expanded(
                              child: Text('I agree to the Terms & Conditions'),
                            ),
                          ],
                        ),
                        if (!value)
                          const Padding(
                            padding: EdgeInsets.only(left: 8, bottom: 8),
                            child: Text(
                              'Anda harus menyetujui syarat & ketentuan',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate() && agreed.value) {
                          final vetBloc = context.read<VetBloc>();

                          vetBloc.add(
                            VetRegisterRequested(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text,
                              specialization: specializationController.text.trim(),
                              experienceYears: int.tryParse(experienceController.text.trim()) ?? 0,
                              overview: overviewController.text.trim(),
                              schedule: scheduleController.text.trim(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Create account',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have a vet account? '),
                      GestureDetector(
                        onTap: () => context.go('/vet/login'),
                        child: const Text('Login', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? helper,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label *'),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint ?? 'Enter your $label',
              helperText: helper,
            ),
          ),
        ],
      ),
    );
  }
}
