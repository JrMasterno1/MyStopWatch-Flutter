
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stopwatch/PlatformAlert.dart';

class MyStopWatch extends StatefulWidget {
  static const route = '/stopwatch';
  final String name ;
  final String email;
  const MyStopWatch({Key? key, this.name = "", this.email = ""}) : super(key: key);

  @override
  _MyStopWatchState createState() => _MyStopWatchState();
}

class _MyStopWatchState extends State<MyStopWatch> {
  bool isTicking = false;
  final laps = <int>[];
  final itemHeight = 60.0;
  final scrollController = ScrollController();

  String _secondsText(int mili) {
    final seconds = mili / 1000;
    return '$seconds seconds';
  }

  @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context)?.settings.arguments.toString() ?? "";
    return Scaffold(
      appBar: AppBar(title: Text(name),),
      body: Column(
        children: [
          Expanded(child: _buildCounter(context)),
          Expanded(child: _buildLapDisplay())
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lap ${laps.length + 1}',
            style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),
          ),
          Text(
            _secondsText(_miliseconds),
            style: Theme
                .of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.white),
          ),
          SizedBox(height: 20,),
          _buildControl()
        ],
      ),
    );
  }

  Widget _buildControl() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Start'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  foregroundColor: MaterialStateProperty.all(Colors.white)
              ),
              onPressed: _startTimer,
            ),
            SizedBox(width: 20,),
            ElevatedButton(
              child: Text('Lap'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow)
              ),
              onPressed: _lap,
            ),
            SizedBox(width: 20,),
            Builder(
              builder: (context) {
                return TextButton(
                  child: Text('Stop'),
                  onPressed: () => _stopTimer(context),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      foregroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                );
              }
            )
          ],
        );
  }

  void _lap() {
    if(isTicking){
      setState(() {
        laps.add(_miliseconds);
        _miliseconds = 0;
      });
      scrollController.animateTo(
        itemHeight * laps.length,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  void _startTimer() {
    if (!isTicking) {
      timer = Timer.periodic(Duration(milliseconds: 100), _onTick);
      _miliseconds = 0;
      setState(() {
        isTicking = true;
        laps.clear();
      });
    }
  }

  void _stopTimer(BuildContext context) {
    if (isTicking) {
      timer?.cancel();
      setState(() {
        isTicking = false;
      });
      final controller = showBottomSheet(context: context, builder: _buildRunCompleteSheet);
      Future.delayed(Duration(seconds: 5)).then((value) => {controller.close()});
    }
  }
  Widget _buildRunCompleteSheet(BuildContext context){
    final totalRuntime = laps.fold(
        _miliseconds,
            (total, lap) => int.parse(total.toString()) + int.parse(lap.toString())
    );

    return SafeArea(
      child: Container(
        color: Theme.of(context).cardColor,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Run Finished !', style: Theme.of(context).textTheme.headline6,),
              Text('Total run time is ${_secondsText(totalRuntime)}')
            ],
          ),
        ),
      ),
    );
  }
  void _onTick(Timer time) {
    setState(() {
      _miliseconds += 100;
    });
  }
  Widget _buildLapDisplay(){
    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        itemExtent: itemHeight,
        itemCount: laps.length,
        itemBuilder: (context, index) {
          final mili = laps[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 50),
            title: Text('Lap ${index + 1}'),
            trailing: Text(_secondsText(mili)),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  int _miliseconds = 0;
  Timer? timer;
}
