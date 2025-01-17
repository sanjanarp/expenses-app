import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart ';
import 'package:flutter_expenses/widgets/adaptive_flat_button.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx){
    print("Constructor NewTransactionWidget");
  }

  @override
  _NewTransactionState createState() {
     print("createState NewTransactionWidget");
   return  _NewTransactionState();}
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  _NewTransactionState() {
    print("Constructor NewTransaction State");
  }

  @override
  void initState() {
    print('initState()');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    print("didUpdateWidget()");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print("dispose()");
    super.dispose();
  }

  void _submitData() {
    if(_amountController.text.isEmpty){
      return;
    }
    final enteredTitle =  _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if(enteredTitle.isEmpty || enteredAmount <=0 || _selectedDate == null )
      {
        return;
      }

    widget.addTx(
       enteredTitle,
        enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
}

void _presentDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020) ,
        lastDate: DateTime.now()
    ).then((pickedDate) {
      if(pickedDate == null){
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });

    });
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
          child: Container(
            padding:  EdgeInsets.only(
                top: 10, left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                  //onChanged: (value) {titleInput = value;},
                ),
                TextField(decoration: InputDecoration(labelText: 'Amount '),
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitData(),
                  //onChanged: (value) {amountInput= value;},
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Text(
                          _selectedDate == null
                              ?'No date chosen!'
                              : 'Chosen Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                       AdaptiveFlatButton('Choose Date', _presentDatePicker),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: _submitData,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text('Add Transaction'),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
