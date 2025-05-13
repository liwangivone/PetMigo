part of 'pages.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome back",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Image.asset('assets/images/petmigo_logo.png', height: 360),
                const SizedBox(height: 24),

                _PhoneInput(),
                const SizedBox(height: 16),
                _PasswordInput(),
                const SizedBox(height: 24),

                _LoginButton(),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone number *',
            hintText: '0895-xxx-xxx',
            border: UnderlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<LoginBloc>().add(PhoneChanged(value)),
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
          decoration: const InputDecoration(
            labelText: 'Password *',
            border: UnderlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<LoginBloc>().add(PasswordChanged(value)),
        );
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
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF9924F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            onPressed: state.isValid
                ? () {
                    context.read<LoginBloc>().add(LoginSubmitted());
                    Navigator.pushReplacementNamed(context, '/dashboard');
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