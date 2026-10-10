import 'package:flutter/material.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'icon': Icons.local_offer_outlined,
        'title': 'Special Beauty Offer',
        'message': 'Get amazing discounts on selected beauty products.',
        'time': '2 min ago',
      },
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'New Arrivals',
        'message': 'Check out the latest beauty products now available.',
        'time': '1 hour ago',
      },
      {
        'icon': Icons.favorite_border,
        'title': 'Wishlist Reminder',
        'message': 'Some of your saved products are waiting for you.',
        'time': '3 hours ago',
      },
      {
        'icon': Icons.local_shipping_outlined,
        'title': 'Free Delivery',
        'message': 'Enjoy free delivery on selected orders.',
        'time': 'Yesterday',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF5F3),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E3DC),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          notification['icon'] as IconData,
                          color: Colors.black,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  notification['time'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Text(
                              notification['message'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
