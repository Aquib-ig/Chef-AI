// lib/features/presentation/notification_screen/notification_screen.dart
import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:chef_ai/features/widgets/gradient_container.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Simple notification data
  List<Map<String, dynamic>> get notifications => [
    {
      'title': 'New Recipe Available! 🍰',
      'body':
          'Try our delicious Chocolate Lava Cake recipe with step-by-step instructions.',
      'time': '30m ago',
      'icon': Icons.restaurant_rounded,
    },
    {
      'title': 'Order Ready for Pickup',
      'body': 'Your order #2024001 is ready! Please collect within 30 minutes.',
      'time': '1h ago',
      'icon': Icons.shopping_bag_rounded,
    },
    {
      'title': '50% Off Weekend Special! 🔥',
      'body': 'Get amazing discounts on premium recipes this weekend only.',
      'time': '3h ago',
      'icon': Icons.local_offer_rounded,
    },
    {
      'title': 'Cooking Reminder',
      'body': 'Don\'t forget to check your slow cooker meal in 2 hours!',
      'time': '5h ago',
      'icon': Icons.schedule_rounded,
    },
    {
      'title': 'Weekly Recipe Digest',
      'body': 'Here are the most popular recipes from this week!',
      'time': '1d ago',
      'icon': Icons.email_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: GradientContainer(
        isDark: isDark,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification, isDark, context);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    Map<String, dynamic> notification,
    bool isDark,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(notification['icon'], color: Colors.orange, size: 24),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              notification['body'],
              style: TextStyle(
                color: (isDark ? Colors.white : Colors.black87).withOpacity(
                  0.7,
                ),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              notification['time'],
              style: TextStyle(
                color: (isDark ? Colors.white : Colors.black87).withOpacity(
                  0.5,
                ),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opened: ${notification['title']}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
