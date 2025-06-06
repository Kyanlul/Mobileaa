// class UserModel {
//   final String? id;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String nationality;
//   final String gender;
//   final bool acceptedTerms;
//   final bool acceptedMarketing;
//
//   UserModel({
//     this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.nationality,
//     required this.gender,
//     required this.acceptedTerms,
//     required this.acceptedMarketing,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'firstName': firstName,
//       'lastName': lastName,
//       'email': email,
//       'nationality': nationality,
//       'gender': gender,
//       'acceptedTerms': acceptedTerms,
//       'acceptedMarketing': acceptedMarketing,
//     };
//   }
//
//   factory UserModel.fromJson(Map<String, dynamic> json, String id) {
//     return UserModel(
//       id: id,
//       firstName: json['firstName'] ?? '',
//       lastName: json['lastName'] ?? '',
//       email: json['email'] ?? '',
//       nationality: json['nationality'] ?? '',
//       gender: json['gender'] ?? '',
//       acceptedTerms: json['acceptedTerms'] ?? false,
//       acceptedMarketing: json['acceptedMarketing'] ?? false,
//     );
//   }
// }