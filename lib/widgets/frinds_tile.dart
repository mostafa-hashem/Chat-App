import 'package:flutter/material.dart';

import '../shared/styles/app_colors.dart';

class FriendsTile extends StatelessWidget {
  final String userName;
  final String userEmail;

  const FriendsTile({super.key, required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName),
            Text(userEmail),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // Add friend functionality
            // You can add the required functionality here
          },
          child: const Icon(
            Icons.person_add,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}