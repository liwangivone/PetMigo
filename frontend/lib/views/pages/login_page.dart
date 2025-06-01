part of 'pages.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            // Navigasi ke halaman dashboard ketika login sukses
            context.go('/dashboard');
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    "Welcome back",
                    style: GoogleFonts.poppins(
                      fontSize: 28, 
                      fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    flex: 3,
                    child: Image.asset(
                      'assets/images/petmigo_logo.png',
                      height: screenHeight * 0.28,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Input dan tombol login
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _EmailInput(),
                        const SizedBox(height: 16),
                        _PasswordInput(),
                        const SizedBox(height: 8),
                        _ErrorMessage(),
                        const SizedBox(height: 16),
                        _LoginButton(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/register'),
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  color: Colors.blue, 
                                  decoration: TextDecoration.underline, 
                                  decorationColor: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
            hintText: 'ivone@gmail.com',
            border: const UnderlineInputBorder(),
            errorText: state.errorMessage != null && state.email.isEmpty
                ? 'Email is required'
                : null,
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
            labelStyle: GoogleFonts.poppins(),
            hintText: '*******',
            hintStyle: GoogleFonts.poppins(),
            border: const UnderlineInputBorder(),
            errorText: state.errorMessage != null && state.password.isEmpty
                ? 'Password is required'
                : null,
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
        if (state.errorMessage != null && 
            state.email.isNotEmpty && 
            state.password.isNotEmpty) {
          return Text(
            state.errorMessage!,
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 14,
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
        return Padding(
        padding: const EdgeInsets.fromLTRB(60, 0, 60, 120),
        child: SizedBox(
          width: double.infinity,
          height: 45,
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9052),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  onPressed: state.isValid
                      ? () {
                          context.read<LoginBloc>().add(LoginSubmitted());
                          context.go('/dashboard');
                        }
                      : null,
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                ),
          ),
        ); 
      },
    );
  }
}
