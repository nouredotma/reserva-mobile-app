import 'package:flutter/material.dart';
import 'package:reservamobile/app/theme/app_colors.dart';
import 'package:reservamobile/core/widgets/ui_kit.dart';

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

bool get hasUnreadNotifications =>
    _mockNotifications.any((item) => item.isUnread);

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleSpacing: 2,
          title: const Text(
            'Notifications',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 120),
          children: const <Widget>[
            AppSkeletonBox(height: 74),
            SizedBox(height: 10),
            AppSkeletonBox(height: 74),
            SizedBox(height: 10),
            AppSkeletonBox(height: 74),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 2,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 120),
        itemCount: _mockNotifications.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1,
          color: Color(0xFFEAEAEA),
          thickness: 1,
        ),
        itemBuilder: (context, index) {
          final item = _mockNotifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: item.isUnread
                        ? AppColors.primary.withValues(alpha: 0.18)
                        : const Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.isUnread
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_none_outlined,
                    size: 19,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.15,
                                fontWeight:
                                    item.isUnread ? FontWeight.w700 : FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.timeLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.body,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isUnread) ...[
                  const SizedBox(width: 8),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
