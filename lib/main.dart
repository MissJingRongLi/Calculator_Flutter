import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'number.dart';
import 'operator.dart';
import 'result.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Calculator',
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  List<Result> results = [];
  String currentDisplay = '0';

  // 计算结果按钮
  onResultButtonPressed(display) {
    if (results.length > 0) {
      var result = results[results.length - 1];
      // 点击 = （计算结果和 按钮）
      if (display == '=') {
        result.result = result.oper.calculator(
            double.parse(result.firstNum), double.parse(result.secondNum));
      }
      // 点击 << 即复位清除按钮
      else if (display == '<<') {
        results.removeLast();
      }
    }
    pickCurrentDisplay();
  }

  //操作符按钮
  onOperatorButtonPressed(Operator oper) {
    if (results.length > 0) {
      var result = results[results.length - 1];
      if (result.result != null) {
        var newRes = Result();
        newRes.firstNum = currentDisplay;
        newRes.oper = oper;
        results.add(newRes);
      } else if (result.firstNum != null) {
        result.oper = oper;
      }
    }
    pickCurrentDisplay();
  }

  // 数字按键
  onNumberButtonPressed(Number number) {
    var result = results.length > 0 ? results[results.length - 1] : Result();
    // 没有输入第二个操作数或者操作符的时候
    if (result.firstNum == null || result.oper == null) {
      // 计算结果不变
      result.firstNum = number.apply(currentDisplay);
    } else if (result.result == null) {
      // 结果为空
      if (result.secondNum == null) {
        currentDisplay = '0';
      }
      result.secondNum = number.apply(currentDisplay);
    } else {
      var newRes = Result();
      currentDisplay = '0';
      newRes.firstNum = number.apply(currentDisplay);
      results.add(newRes);
    }
    if (results.length == 0) {
      results.add(result);
    }
    pickCurrentDisplay();
  }

  pickCurrentDisplay() {
    this.setState(() {
      var display = '0';
      results.removeWhere((item) =>
          item.firstNum == null && item.secondNum == null && item.oper == null);
      if (results.length > 0) {
        var result = results[results.length - 1];
        print(result.result);
        print(results[0]);
        if (result.result != null) {
          display = format(result.result);
        } else if (result.secondNum != null && result.oper != null) {
          display = result.secondNum;
        } else if (result.firstNum != null) {
          display = result.firstNum;
        }
      }
      currentDisplay = display;
    });
  }

  String format(num number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Expanded(
              key: Key('Current_Display'),
              flex: 2,
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: Container(
                  color: Colors.lightBlue[300],
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16.0),
                  child: ResultDisplay(result: currentDisplay),
                ),
              ),
            ),
            Expanded(
                key: Key('History_Display'),
                child: FractionallySizedBox(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Container(
                      color: Colors.black54,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: results.reversed.map((result) {
                            return HistoryBlock(result: result);
                          }).toList()),
                    )),
                flex: 1),
            Expanded(
                key: Key('Number_Button_Line_1'),
                child: NumberButtonLine(
                  array: [
                    NormalNumber('1'),
                    NormalNumber('2'),
                    NormalNumber('3')
                  ],
                  onPress: onNumberButtonPressed,
                ),
                flex: 1),
            Expanded(
                key: Key('Number_Button_Line_2'),
                child: NumberButtonLine(
                  array: [
                    NormalNumber('4'),
                    NormalNumber('5'),
                    NormalNumber('6')
                  ],
                  onPress: onNumberButtonPressed,
                ),
                flex: 1),
            Expanded(
                key: Key('Number_Button_Line_3'),
                child: NumberButtonLine(
                  array: [
                    NormalNumber('7'),
                    NormalNumber('8'),
                    NormalNumber('9')
                  ],
                  onPress: onNumberButtonPressed,
                ),
                flex: 1),
            Expanded(
                key: Key('Number_Button_Line_4'),
                child: NumberButtonLine(
                  array: [SymbolNumber(), NormalNumber('0'), DecimalNumber()],
                  onPress: onNumberButtonPressed,
                ),
                flex: 1),
            Expanded(
                key: Key('Operator_Group'),
                child: OperatorGroup(onOperatorButtonPressed),
                flex: 1),
            Expanded(
                key: Key('Result_Button_Area'),
                child: Row(
                  children: <Widget>[
                    ResultButton(
                      display: '<<',
                      color: Colors.red,
                      onPress: onResultButtonPressed,
                    ),
                    ResultButton(
                        display: '=',
                        color: Colors.green,
                        onPress: onResultButtonPressed),
                  ],
                ),
                flex: 1)
          ],
        ),
      ),
    );
  }
}
