class ProfileModel {
  String? fullName;
  String? email;
  String? bio;
  DateTime? dateOfBirth;
  String? profileImage;

  ProfileModel({
    this.fullName,
    this.email,
    this.bio,
    this.dateOfBirth,
    this.profileImage,
  });

  // Parse API response
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'] as String)
          : null,
      profileImage: json['profile_image'] as String?,
    );
  }

  // Convert to JSON for API updates
  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (bio != null) 'bio': bio,
      if (dateOfBirth != null)
        'date_of_birth': dateOfBirth!.toIso8601String(),
      if (profileImage != null) 'profile_image': profileImage,
    };
  }
}