class Review {
  final String review_id;
  final String review_title;
  final String review_content;
  final String user_name;

  Review({
    required this.review_id,
    required this.review_title,
    required this.review_content,
    required this.user_name,
  });

  // Tạo từ JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      review_id: json['review_id'],
      review_title: json['review_title'],
      review_content: json['review_content'],
      user_name: json['user_name'],
    );
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
        review_id: map['review_id'] ?? '',
        user_name: map['review_name'] ?? '',
        review_title: map['review_title'] ?? '',
        review_content: map['review_content']);
  }

  // Chuyển đổi thành JSON
  Map<String, dynamic> toMap() {
    return {
      'review_id': review_id,
      'review_title': review_title,
      'review_content': review_content,
      'user_name': user_name,
    };
  }
}
