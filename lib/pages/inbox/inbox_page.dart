import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Explore"),
      backgroundColor: Colors.white,
    ),
    body: const Center(
      child: Text("Explore destinations and interests here.", style: TextStyle(fontSize: 18)),
    ),
  );
}

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget _notificationTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 22),
      children: [
        Icon(Icons.notifications_none, size: 84, color: Colors.blue.withOpacity(0.45)),
        const SizedBox(height: 22),
        const Text(
          "No notifications yet",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        const Text(
          "You'll get alerts about your trips and account here. Ready to book your next trip?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 220,
          child: ElevatedButton(
            onPressed: () => Get.to(() => const ExplorePage()),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            child: const Text("Start exploring", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _messagesTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 22),
      children: [
        Icon(Icons.chat_bubble_outline, size: 84, color: Colors.blue.withOpacity(0.45)),
        const SizedBox(height: 26),
        const Text(
          "No messages yet",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        const Text(
          "Hotels and properties can message you here after you book a stay.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Inbox",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        bottom: const TabBar(
          tabs: [
            Tab(text: "Notifications"),
            Tab(text: "Messages"),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: const TabBarView(
        children: [
          // Pass only stateless, constrained tab content!
          _TabContent(type: TabContentType.notifications),
          _TabContent(type: TabContentType.messages),
        ],
      ),
    ),
  );
}

// Tab Content Helper - stateless, always works
enum TabContentType { notifications, messages }
class _TabContent extends StatelessWidget {
  final TabContentType type;
  const _TabContent({required this.type, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == TabContentType.notifications) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 22),
        children: [
          Icon(Icons.notifications_none, size: 84, color: Colors.blue.withOpacity(0.45)),
          const SizedBox(height: 22),
          const Text(
            "No notifications yet",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          const Text(
            "You'll get alerts about your trips and account here. Ready to book your next trip?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const ExplorePage()),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: const Text("Start exploring", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      );
    } else {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 22),
        children: [
          Icon(Icons.chat_bubble_outline, size: 84, color: Colors.blue.withOpacity(0.45)),
          const SizedBox(height: 26),
          const Text(
            "No messages yet",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          const Text(
            "Hotels and properties can message you here after you book a stay.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ],
      );
    }
  }
}