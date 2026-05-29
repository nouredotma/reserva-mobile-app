import 'package:flutter/material.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/widgets/scroll_aware_scaffold.dart';

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.body,
    required this.timeLabel,
    this.isUnread = false,
  });

  final String title;
  final String body;
  final String timeLabel;
  final bool isUnread;
}

const _mockNotifications = <_NotificationItem>[
  _NotificationItem(
    title: 'Booking confirmed',
    body: 'Your table at Le Jardin is confirmed for tomorrow at 20:00.',
    timeLabel: '2h ago',
    isUnread: true,
  ),
  _NotificationItem(
    title: 'Reminder',
    body: 'Spa session at Royal Mansour starts in 24 hours.',
    timeLabel: 'Yesterday',
    isUnread: true,
  ),
  _NotificationItem(
    title: 'Special offer',
    body: '20% off day passes in Marrakech this weekend.',
    timeLabel: '3 days ago',
  ),
];

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollAwareScaffold(
      title: 'Notifications',
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _mockNotifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = _mockNotifications[index];
          return Card(
            child: ListTile(
              title: Text(item.title),
              subtitle: Text('${item.body}\n${item.timeLabel}'),
              isThreeLine: true,
              trailing: item.isUnread
                  ? const Icon(
                      Icons.circle,
                      size: 10,
                      color: AppColors.primary,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
