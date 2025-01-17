import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
 const TransactionItem({
    Key key,
   @required this.transaction,
   @required this.deleteTx,
}) : super(key: key);

 final Transaction transaction;
 final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
   Color _bgColor;


  @override
  void initState() {
   final availableColors = [
      Colors.orange[100],
      Colors.pink[100],
      Colors.blue[100],
      Colors.grey[100],
      Colors.purple[100]];

   _bgColor = availableColors[Random().nextInt(5)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 5.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:_bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
                child: Text('\$${widget.transaction.amount}')),
          ),
        ),
        title:  Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date)),
        trailing: MediaQuery.of(context).size.width > 360 ?
        FlatButton.icon(
            onPressed:() => widget.deleteTx( widget.transaction.id),
            textColor: Theme.of(context).errorColor,
            icon: Icon(Icons.delete),
            label: Text("Delete"))
            : IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => widget.deleteTx( widget.transaction.id),) ,

      ),
    );
  }
}
