import 'package:cloud_firestore/cloud_firestore.dart';

class Poem {
  final String id;
  final String title;
  final String poetName;
  final String category;
  final String body;
  final int readingTimeMinutes;
  final bool isPublished;
  final bool isFeatured;
  final int likesCount;

  Poem({
    required this.id,
    required this.title,
    required this.poetName,
    required this.category,
    required this.body,
    required this.readingTimeMinutes,
    required this.isPublished,
    this.isFeatured = false,
    this.likesCount = 0,
  });

  factory Poem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Poem(
      id: doc.id,
      title: data['title'] ?? 'अनाम कविता',
      poetName: data['poet_name'] ?? 'अज्ञात',
      category: data['category'] ?? 'सामान्य',
      body: data['body'] ?? '',
      readingTimeMinutes: data['estimated_reading_minutes'] ?? 2,
      isPublished: data['is_published'] ?? false,
      isFeatured: data['is_featured'] ?? false,
      likesCount: data['likes_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'poet_name': poetName,
      'category': category,
      'body': body,
      'estimated_reading_minutes': readingTimeMinutes,
      'is_published': isPublished,
      'is_featured': isFeatured,
      'likes_count': likesCount,
    };
  }
}

