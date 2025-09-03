import 'dart:convert';

import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  final int jobId; // Pass the job ID to fetch related reviews

  ReviewScreen({required this.jobId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List reviews = [];
  double rating = 0;
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //fetchReviews();
  }

  // 🔹 Fetch Reviews from API
/*  Future<void> fetchReviews() async {
    final response = await http.get(Uri.parse('https://yourapi.com/get_reviews.php?job_id=${widget.jobId}'));
    if (response.statusCode == 200) {
      setState(() {
        reviews = json.decode(response.body);
      });
    } else {
      print("Error fetching reviews");
    }
  }*/

  // 🔹 Submit Review to API
  Future<void> submitReview() async {
   /* if (rating == 0 || reviewController.text.isEmpty) return;

    final response = await http.post(
      Uri.parse('https://yourapi.com/add_review.php'),
      body: {
        'job_id': widget.jobId.toString(),
        'rating': rating.toString(),
        'review': reviewController.text,
      },
    );

    if (response.statusCode == 200) {
      reviewController.clear();
      rating = 0;
      fetchReviews(); // Refresh after adding review
    } else {
      print("Failed to submit review");
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reviews")),
      body: Column(
        children: [
          // ⭐ Rating Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text("Rate this job", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          rating = index + 1.0;
                        });
                      },
                    );
                  }),
                ),
                TextField(
                  controller: reviewController,
                  decoration: InputDecoration(hintText: "Write a review..."),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: submitReview,
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
          Divider(),
          // 📝 List of Reviews
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person, size: 40),
                  title: Text(reviews[index]['review']),
                  subtitle: Row(
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < int.parse(reviews[index]['rating']) ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}