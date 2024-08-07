import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/notification.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<NotificationAPI> _notificationFuture;

  @override
  void initState() {
    super.initState();
    _notificationFuture = NotificationAPI.notificationlist();
  }

  void _showDateTimeDialog(String? dateTimeText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Date and Time'),
          content: Text(dateTimeText ?? 'No date-time provided'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<NotificationAPI>(
          future: _notificationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching notifications'));
            } else if (!snapshot.hasData ||
                snapshot.data!.notificationDetails == null ||
                snapshot.data!.notificationDetails!.isEmpty) {
              return Center(child: Text('No notifications available'));
            } else {
              List<NotificationDetails> notifications =
                  snapshot.data!.notificationDetails!;
              return ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  NotificationDetails notification = notifications[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: ClipOval(
                        child: Image.network(
                          notification.image ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title ?? 'No title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _showDateTimeDialog(notification.dateTimeText);
                          },
                        ),
                      ],
                    ),
                    subtitle: Text(
                      notification.message ?? 'No message',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    onTap: () {
                      // Handle notification tap
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
