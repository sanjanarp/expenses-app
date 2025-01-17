import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expenses/widgets/transaction_list.dart';

import './widgets/new_transactions.dart';
import './models/transaction.dart';
import './widgets/chart.dart';


void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([
  //DeviceOrientation.portraitDown,
  //DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal expenses',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme:
          ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                   fontSize: 20,
                   fontWeight: FontWeight.bold),),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions= [

  ];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
   void didChangeAppLifecycleState(AppLifecycleState state) {
          print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions{
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
          DateTime.now().subtract(
              Duration(days:  7)
          ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle,
      double txAmount,
      DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date:chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
        context: ctx ,
        builder: (_) {
          return GestureDetector(
            onTap:() {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          ) ;
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget) {
    [Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Text('Show Chart', style: Theme.of(context).textTheme.title,),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value:_showChart ,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                }
                );
              }
              )
        ]
    ),
      _showChart? Container(
          height: (mediaQuery.size.height
              - appBar.preferredSize.height
              - mediaQuery.padding.top) * 0.7,
          child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget) {
    return [Container(
        height: (mediaQuery.size.height
            - appBar.preferredSize.height
            - mediaQuery.padding.top) * 0.3,
        child: Chart(_recentTransactions)
    ),
    txListWidget];
  }

  @override
  Widget build(BuildContext context) {
    print("build () MyHomePageState");
    final mediaQuery= MediaQuery.of(context);
   final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
          middle: Text('Personal expenses'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () {
                _startAddNewTransaction(context);
              },
            )
          ],),
    )
        :AppBar(
      title: Text('Personal expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add) ,
          onPressed: () {
            _startAddNewTransaction(context);
          },)
      ],
    );
    final txListWidget = Container(
        height: (mediaQuery.size.height
            - appBar.preferredSize.height
            - mediaQuery.padding.top) * 0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: <Widget>[
          if(isLandscape) ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
          if(!isLandscape) ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
        ],
      ),
    ),) ;
    return Platform.isIOS
        ? CupertinoPageScaffold( child: pageBody, navigationBar: appBar ,)
        : Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
         ? Container()
         : FloatingActionButton(
        child: Icon(Icons.add, color: Theme.of(context).primaryColorDark,),
         onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
