part of 'pages.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(const LoadUser()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF9B58),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/dashboard');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              context.go('/edit-profile');
            },
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoggedOut) {
            context.go('/login');
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF9B58),
              ),
            );
          }

          if (state is UserError && state.user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(const LoadUser());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          User? user;
          if (state is UserLoaded) {
            user = state.user;
          } else if (state is UserError && state.user != null) {
            user = state.user;
          }

          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          return ProfileContent(user: user);
        },
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final User user;

  const ProfileContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with profile picture
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFF9B58),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 24),
          child: Center(
            child: Column(
              children: [
                // Profile picture with camera icon
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: user.profileImageUrl != null
                          ? NetworkImage(user.profileImageUrl!)
                          : null,
                      child: user.profileImageUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  user.id,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Contact information card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.deepOrange),
                    title: Text(
                      user.email,
                      style: const TextStyle(fontSize: 14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    minLeadingWidth: 24,
                    dense: true,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.deepOrange),
                    title: Text(
                      user.phone,
                      style: const TextStyle(fontSize: 14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    minLeadingWidth: 24,
                    dense: true,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.deepOrange),
                    title: Text(
                      user.dateOfBirth ?? 'Not set',
                      style: const TextStyle(fontSize: 14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    minLeadingWidth: 24,
                    dense: true,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Subscription status
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Subscription status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5DAEFF), Color(0xFF2E86DE)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.go('/subscription');
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.card_giftcard, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.isPremium ? 'Premium account' : 'Free account',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  user.isPremium
                                      ? 'You have access to all premium features'
                                      : 'Start your subscription to access all the premium features',
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Logout button
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextButton.icon(
            onPressed: () {
              context.read<UserBloc>().add(const LogoutUser());
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(const LoadUser()),
      child: const EditProfileView(),
    );
  }
}

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  String? selectedDate;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _initializeControllers(User user) {
    if (currentUser?.id != user.id) {
      nameController.text = user.name;
      phoneController.text = user.phone;
      emailController.text = user.email;
      selectedDate = user.dateOfBirth;
      currentUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF9B58),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/profile');
          },
        ),
        actions: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return TextButton(
                onPressed: state is UserUpdating ? null : _saveProfile,
                child: state is UserUpdating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF9B58),
              ),
            );
          }

          if (state is UserError && state.user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(const LoadUser());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          User? user;
          if (state is UserLoaded) {
            user = state.user;
          } else if (state is UserUpdating) {
            user = state.user;
          } else if (state is UserError && state.user != null) {
            user = state.user;
          }

          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          _initializeControllers(user);

          return EditProfileContent(
            user: user,
            nameController: nameController,
            emailController: emailController,
            phoneController: phoneController,
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
            onSave: _saveProfile,
            isUpdating: state is UserUpdating,
          );
        },
      ),
    );
  }

  void _saveProfile() {
    final userBloc = context.read<UserBloc>();
    
    if (currentUser == null) return;

    final updatedUser = currentUser!.copyWith(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      dateOfBirth: selectedDate,
    );

    userBloc.add(UpdateUser(user: updatedUser));
  }
}

class EditProfileContent extends StatelessWidget {
  final User user;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? selectedDate;
  final Function(String) onDateSelected;
  final VoidCallback onSave;
  final bool isUpdating;

  const EditProfileContent({
    super.key,
    required this.user,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onSave,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile picture area
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFF9B58),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          _selectProfilePhoto(context);
                        },
                        child: const Icon(Icons.camera_alt, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Form fields
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Name field
                TextField(
                  controller: nameController,
                  enabled: !isUpdating,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFFF9B58)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Email field
                TextField(
                  controller: emailController,
                  enabled: !isUpdating,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFFF9B58)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                
                const SizedBox(height: 16),
                
                // Phone field
                TextField(
                  controller: phoneController,
                  enabled: !isUpdating,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFFF9B58)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 16),
                
                // Date of Birth field
                InkWell(
                  onTap: isUpdating ? null : () {
                    _selectDate(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate ?? 'Date of Birth',
                          style: TextStyle(
                            color: selectedDate != null ? Colors.black : Colors.grey[600],
                          ),
                        ),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF9B58),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      onDateSelected("${picked.day}/${picked.month}/${picked.year}");
    }
  }
  
  void _selectProfilePhoto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Simulate image selection
                  context.read<UserBloc>().add(
                    const UpdateUserProfileImage(
                      imagePath: 'https://via.placeholder.com/150',
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // Simulate camera capture
                  context.read<UserBloc>().add(
                    const UpdateUserProfileImage(
                      imagePath: 'https://via.placeholder.com/150/0000FF',
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}