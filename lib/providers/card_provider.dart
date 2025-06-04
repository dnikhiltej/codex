import 'package:flutter/material.dart';
import '../models/card_item.dart';

class CardProvider extends ChangeNotifier {
  final List<CardItem> _cards = [];

  List<CardItem> get cards {
    _autoReset();
    _cards.sort((a, b) => a.isPaid == b.isPaid ? 0 : (a.isPaid ? 1 : -1));
    return List.unmodifiable(_cards);
  }

  void addCard(CardItem card) {
    _cards.add(card);
    notifyListeners();
  }

  void updateCard(int index, CardItem card) {
    _cards[index] = card;
    notifyListeners();
  }

  void markPaid(int index) {
    _cards[index].isPaid = true;
    _cards[index].lastPaidOn = DateTime.now();
    notifyListeners();
  }

  void _autoReset() {
    final now = DateTime.now();
    for (var card in _cards) {
      if (now.day == card.billDate) {
        card.isPaid = false;
      }
    }
  }
}
