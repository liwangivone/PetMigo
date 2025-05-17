part of 'pages.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(),
      child: Scaffold(
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
                          'assets/logo_petmigo.png',
                          height: 80,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text("Full name *"),
                      TextField(
                        onChanged: (val) => bloc.add(RegisterNameChanged(val)),
                        decoration: const InputDecoration(hintText: "Enter your full name"),
                      ),
                      const SizedBox(height: 16),
                      Text("Phone number *"),
                      TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => bloc.add(RegisterPhoneChanged(val)),
                        decoration: const InputDecoration(hintText: "0895-xxx-xxx"),
                      ),
                      const SizedBox(height: 16),
                      Text("Password *"),
                      TextField(
                        obscureText: true,
                        onChanged: (val) => bloc.add(RegisterPasswordChanged(val)),
                        decoration: const InputDecoration(hintText: "********"),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: state.agreed,
                            onChanged: (_) => bloc.add(RegisterTermsToggled()),
                          ),
                          const Expanded(
                            child: Text("I have read and agreed to the"),
                          ),
                        ],
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
                          onPressed: state.isValid
                              ? () {
                                  bloc.add(RegisterSubmitted());
                                  // Navigasi ke halaman login
                                  context.go('/login');
                                }
                              : null,
                          child: const Text("Create account", style: TextStyle(color: Colors.white)),
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
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
