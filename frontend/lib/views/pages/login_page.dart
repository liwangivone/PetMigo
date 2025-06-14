part of 'pages.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(authRepository: AuthRepository()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isSuccess && state.user != null) {
            context.go('/dashboard');
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  const Spacer(flex: 1),

                  const Text(
                    "Welcome back",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 1),

                  Flexible(
                    flex: 3,
                    child: Image.asset(
                      'assets/images/petmigo_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Spacer(flex: 1),

                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _EmailInput(),
                          const SizedBox(height: 16),
                          _PasswordInput(),
                          _ErrorMessage(),
                          const SizedBox(height: 24),
                          _LoginButton(),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () => context.go('/register'),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Example@example.com',
            border: const UnderlineInputBorder(),
            errorText: state.submitted && state.email.isEmpty
                ? 'Email tidak boleh kosong'
                : (state.submitted && state.email.isNotEmpty && !state.isValidEmail
                    ? 'Format email tidak valid'
                    : null),
          ),
          onChanged: (value) =>
              context.read<LoginBloc>().add(EmailChanged(value)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const UnderlineInputBorder(),
            errorText: state.submitted && state.password.isEmpty
                ? 'Password tidak boleh kosong'
                : (state.submitted && state.password.isNotEmpty && state.password.length < 6
                    ? 'Password minimal 6 karakter'
                    : null),
          ),
          onChanged: (value) =>
              context.read<LoginBloc>().add(PasswordChanged(value)),
        );
      },
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9924F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  onPressed: !state.isLoading
                      ? () {
                          context.read<LoginBloc>().add(LoginSubmitted());
                        }
                      : null,
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        );
      },
    );
  }
}
