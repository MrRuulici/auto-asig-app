import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/user.dart';
import 'package:auto_asig/feature/user/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  static const String path = 'profile';
  static const String absolutePath = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _countryController;
  bool _isEditing = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final userData = context.read<UserDataCubit>().state;
    final profileCubit = context.read<ProfileCubit>();
    profileCubit.initializeWithUser(userData.member);
    _firstNameController =
        TextEditingController(text: userData.member.firstName);
    _lastNameController = TextEditingController(text: userData.member.lastName);
    _emailController = TextEditingController(text: userData.member.email);
    _phoneController = TextEditingController(text: userData.member.phone);
    _countryController = TextEditingController(text: userData.member.country);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final userData = context.read<UserDataCubit>().state;
    final profileCubit = context.read<ProfileCubit>();
    final userDataCubit = context.read<UserDataCubit>();

    String? profilePictureUrl;

    // Convert image to base64 if one was selected
    if (_selectedImage != null) {
      try {
        final bytes = await _selectedImage!.readAsBytes();
        String base64Image = base64Encode(bytes);
        profilePictureUrl = 'data:image/jpeg;base64,$base64Image';
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
        return;
      }
    }

    profileCubit
        .updateProfile(
      userId: userData.member.id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      country: _countryController.text,
      profilePictureUrl: profilePictureUrl,
    )
        .then((_) {
      // Update the UserDataCubit with the new profile data
      final updatedMember = UserModel(
        userData.member.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        country: _countryController.text,
        profilePictureUrl: profilePictureUrl ?? userData.member.profilePictureUrl,
      );
      
      userDataCubit.updateMember(updatedMember);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        context.go('/');
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.read<UserDataCubit>().state;

    // Determine which image to show
    ImageProvider profileImage;
    if (_selectedImage != null) {
      profileImage = FileImage(_selectedImage!);
    } else if (userData.member.profilePictureUrl.isNotEmpty &&
        userData.member.profilePictureUrl.startsWith('data:image')) {
      profileImage = MemoryImage(
        base64Decode(userData.member.profilePictureUrl.split(',')[1]),
      );
    } else {
      profileImage = const NetworkImage(defaultProfilePictureUrl);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _isEditing = false),
            ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture with edit button
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: profileImage,
                          backgroundColor: Colors.grey[200],
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryBlue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // User Info Section
                    if (!_isEditing)
                      _buildViewMode(userData)
                    else
                      _buildEditMode(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewMode(var userData) {
    return Column(
      children: [
        _buildInfoCard(
          label: 'First Name',
          value: userData.member.firstName,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          label: 'Last Name',
          value: userData.member.lastName,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          label: 'Email',
          value: userData.member.email,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          label: 'Phone',
          value: userData.member.phone,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          label: 'Country',
          value: userData.member.country,
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return Column(
      children: [
        _buildTextField(
          label: 'First Name',
          controller: _firstNameController,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Last Name',
          controller: _lastNameController,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Phone',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Country',
          controller: _countryController,
        ),
        const SizedBox(height: 32),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state is ProfileLoading ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state is ProfileLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save Changes'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard({required String label, required String value}) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}