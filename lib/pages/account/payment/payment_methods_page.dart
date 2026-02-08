import 'package:flutter/material.dart';
import 'my_account_tab.dart';
import 'other_traveler_tab.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Methods")),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: selectedTab == 0
                        ? Colors.blue
                        : Colors.grey.shade200,
                    child: Text(
                      "My Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedTab == 0 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = 1),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: selectedTab == 1
                        ? Colors.blue
                        : Colors.grey.shade200,
                    child: Text(
                      "Other Travelers",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedTab == 1 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: selectedTab == 0 ? MyAccountTab() : OtherTravelersTab(),
          ),
        ],
      ),
    );
  }
}
