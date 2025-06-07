part of 'pages.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        authRepository: AuthRepository(),
      ),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.success && state.user != null) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Akun berhasil dibuat. Selamat datang, ${state.user!.name}!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            // Navigate to dashboard
            context.go('/dashboard');
          } else if (state.status == RegisterStatus.failure && state.errorMessage != null) {
            // Show error message in snackbar for important errors
            if (state.errorMessage!.contains('server') || 
                state.errorMessage!.contains('koneksi') ||
                state.errorMessage!.contains('terduga')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  final bloc = context.read<RegisterBloc>();
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        const Center(
                          child: Text(
                            "Create your account",
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
                        const SizedBox(height: 32),                        const Text("Full name *"),
                        TextField(
                          onChanged: (val) => bloc.add(RegisterNameChanged(val)),
                          decoration: InputDecoration(
                            hintText: "Enter your full name",
                            errorText: state.submitted && state.name.isEmpty 
                              ? "Nama tidak boleh kosong"
                              : (state.submitted && state.name.trim().length < 2 
                                ? "Nama minimal 2 karakter"
                                : null),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text("Email *"),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) => bloc.add(RegisterEmailChanged(val)),
                          decoration: InputDecoration(
                            hintText: "example@example.com",
                            errorText: state.submitted && state.email.isEmpty 
                              ? "Email tidak boleh kosong"
                              : (state.submitted && state.email.isNotEmpty && !state.isValidEmail 
                                ? "Format email tidak valid"
                                : null),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text("Password *"),
                        TextField(
                          obscureText: true,
                          onChanged: (val) => bloc.add(RegisterPasswordChanged(val)),
                          decoration: InputDecoration(
                            hintText: "********",
                            errorText: state.submitted && state.password.isEmpty 
                              ? "Password tidak boleh kosong"
                              : (state.submitted && state.password.isNotEmpty && state.password.length < 6 
                                ? "Password minimal 6 karakter"
                                : null),
                            helperText: "Password minimal 6 karakter",
                            helperStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: state.agreed,
                              onChanged: (_) => bloc.add(RegisterTermsToggled()),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => bloc.add(RegisterTermsToggled()),
                                child: const Text("I have read and agreed to the Terms & Conditions"),
                              ),
                            ),
                          ],
                        ),
                        if (state.submitted && !state.agreed)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                            child: Text(
                              "Anda harus menyetujui syarat & ketentuan",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        if (state.status == RegisterStatus.failure && 
                            state.errorMessage != null && 
                            state.errorMessage!.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: state.status == RegisterStatus.loading
                                ? null
                                : () {
                                    context.read<RegisterBloc>().add(RegisterSubmitted());
                                  },
                            child: state.status == RegisterStatus.loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    "Create account", 
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () => context.go('/login'),
                              child: const Text("Login", style: TextStyle(color: Colors.blue)),
                            )
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
