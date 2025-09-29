import 'package:flutter/material.dart';
import '../model/restaurant.dart';

class ReviewList extends StatelessWidget {
  final List<CustomerReview> reviews;
  const ReviewList({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(child: Text("Belum ada review."));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final r = reviews[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(r.name, style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(r.review),
            trailing: Text(
              r.date,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      },
    );
  }
}
