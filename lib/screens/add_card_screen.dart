import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/card_item.dart';
import '../providers/card_provider.dart';

class AddCardScreen extends StatefulWidget {
  final int? index;
  final CardItem? card;

  const AddCardScreen({Key? key, this.index, this.card}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _billController = TextEditingController();
  final _dueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _nameController.text = widget.card!.name;
      _billController.text = widget.card!.billDate.toString();
      _dueController.text = widget.card!.dueDate.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _billController.dispose();
    _dueController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final card = CardItem(
        name: _nameController.text,
        billDate: int.parse(_billController.text),
        dueDate: int.parse(_dueController.text),
        lastPaidOn: widget.card?.lastPaidOn,
        isPaid: widget.card?.isPaid ?? false,
      );
      final provider = context.read<CardProvider>();
      if (widget.index != null) {
        provider.updateCard(widget.index!, card);
      } else {
        provider.addCard(card);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.card == null ? 'Add Card' : 'Edit Card')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Card Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _billController,
                decoration: const InputDecoration(labelText: 'Bill Date'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter bill date' : null,
              ),
              TextFormField(
                controller: _dueController,
                decoration: const InputDecoration(labelText: 'Due Date'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter due date' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text(widget.card == null ? 'Add Card' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
