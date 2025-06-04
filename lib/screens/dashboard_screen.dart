import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/card_item.dart';
import '../providers/card_provider.dart';
import 'add_card_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CardProvider>();
    final cards = provider.cards;
    return Scaffold(
      appBar: AppBar(title: const Text('CPR - Card Payment Reminder')),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Card(
            color: card.isPaid ? Colors.green[100] : Colors.red[100],
            child: ListTile(
              title: Text(card.name),
              subtitle: Text('Bill: ${card.billDate}  Due: ${card.dueDate}\nLast Paid: '
                  '${card.lastPaidOn != null ? card.lastPaidOn!.toLocal().toString().split(' ').first : 'Never'}'),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: card.isPaid ? null : () => provider.markPaid(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddCardScreen(index: index, card: card),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddCardScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
