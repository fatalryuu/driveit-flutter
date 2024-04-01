import 'package:driveit/pages/common/button.dart';
import 'package:driveit/pages/common/error_label.dart';
import 'package:driveit/pages/common/profile_input.dart';
import 'package:driveit/services/auth_service.dart';
import 'package:driveit/services/users_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  final TextEditingController _socialController = TextEditingController();

  User user = FirebaseAuth.instance.currentUser!;
  bool _isEditing = false;
  String _pageError = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      UserDB userDB = await UsersService.getUser(user.uid);
      setState(() {
        _nameController.text = userDB.name;
        _surnameController.text = userDB.surname;
        _usernameController.text = userDB.username;
        _birthdayController.text = userDB.birthday;
        _jobController.text = userDB.job;
        _countryController.text = userDB.country;
        _cityController.text = userDB.city;
        _educationController.text = userDB.education;
        _hobbyController.text = userDB.hobby;
        _socialController.text = userDB.social;
      });
    } catch (error) {
      setState(() {
        _pageError = "Error fetching user data";
      });
    }
  }

  Future<void> editProfile() async {
    if (_isEditing) {
      try {
        setState(() {
          _isLoading = true;
        });

        await UsersService.updateUser(
          id: user.uid,
          name: _nameController.text,
          surname: _surnameController.text,
          username: _usernameController.text,
          birthday: _birthdayController.text,
          job: _jobController.text,
          country: _countryController.text,
          city: _cityController.text,
          education: _educationController.text,
          hobby: _hobbyController.text,
          social: _socialController.text,
        );
      } catch (error) {
        setState(() {
          _pageError = "Failed to update user";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> deleteClick() async {
    await AuthService.deleteAccount();
    await UsersService.deleteUser(user.uid);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _birthdayController.dispose();
    _jobController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _educationController.dispose();
    _hobbyController.dispose();
    _socialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32.0),

                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12.0),

                Text(
                  user.email!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4.0),

                // Inputs
                ProfileInput(
                    controller: _nameController,
                    placeholder: "Name",
                    isEditing: _isEditing),
                ProfileInput(
                    controller: _surnameController,
                    placeholder: "Surname",
                    isEditing: _isEditing),
                ProfileInput(
                    controller: _usernameController,
                    placeholder: "Username",
                    isEditing: _isEditing),
                ProfileInput(
                    controller: _birthdayController,
                    placeholder: "Birthday",
                    isEditing: _isEditing),
                ProfileInput(
                    controller: _jobController,
                    placeholder: "Job",
                    isEditing: _isEditing),
                ProfileInput(
                    controller: _countryController,
                    placeholder: "Country",
                    isEditing: _isEditing),
                ProfileInput(
                    controller: _cityController,
                    placeholder: "City",
                    isEditing: _isEditing),
                ProfileInput(
                    controller: _educationController,
                    placeholder: "Education",
                    isEditing: _isEditing),
                ProfileInput(
                    controller: _hobbyController,
                    placeholder: "Hobby",
                    isEditing: _isEditing),
                ProfileInput(
                    controller: _socialController,
                    placeholder: "Social",
                    isEditing: _isEditing),

                if (_pageError.isNotEmpty) ErrorLabel(text: _pageError),

                SizedBox(height: _pageError.isEmpty ? 24.0 : 10.0),

                Button(
                  action: editProfile,
                  text: _isEditing ? "Save changes" : "Edit profile",
                  disabled: _isLoading,
                ),

                const SizedBox(height: 10.0),

                Button(
                  action: AuthService.logOut,
                  text: "Logout",
                  disabled: _isLoading,
                ),

                const SizedBox(height: 30.0),

                Button(
                  action: deleteClick,
                  text: "Delete account",
                  color: Colors.red.shade900,
                  disabled: _isLoading,
                ),

                const SizedBox(height: 36.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
