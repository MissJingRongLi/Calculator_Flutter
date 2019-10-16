import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'operator.dart';

// typedef或函数类型别名有助于定义指向内存中可执行代码的指针。简单地说，typedef可以用作引用函数的指针

typedef void PressOperationCallBack(display);

// 声明结果类
class Result {
  Result();
  String firstNum;
  String secondNum;
  Operator oper;
  num result;
}

// 计算按键 有状态组件
class ResultButton extends StatefulWidget {
  ResultButton({@required this.display, @required this.color, this.onPress});
  final String display;
  final Color color;
  final PressOperationCallBack onPress;
  @override
  _ResultButtonState createState() => _ResultButtonState();
}

class _ResultButtonState extends State<ResultButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 24),
        child: GestureDetector(
          // 点击事件
          onTap: () {
            if (widget.onPress != null) {
              widget.onPress(widget.display);
              setState(() {
               pressed = true; 
              });
              Future.delayed(
                const Duration(milliseconds: 200),
                ()=> setState((){
                  pressed = false;
                })
              );
            }
          },
           child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: pressed ? Colors.grey[200] : null,
                    border: Border.all(color: widget.color, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Text(
                  '${widget.display}',
                  style: TextStyle(
                      fontSize: 36.0,
                      color: widget.color,
                      fontWeight: FontWeight.w300),
                ),
              ),
        ),
      ),
    );
  }
}

// 展示结果
class ResultDisplay extends StatelessWidget {
  ResultDisplay({this.result});
  final String result;
  @override
  Widget build(BuildContext context) {
    // 返回结果文字显示 设置显示样式
    return Text(
      '$result',
      softWrap: false,
      overflow: TextOverflow.fade,
      textScaleFactor: 7.5 / result.length > 1.0 ? 1.0 : 7.5 / result.length,
      style: TextStyle(
        fontSize: 80.0, fontWeight: FontWeight.w500, color: Colors.black
      ),
    );
  }
}

// 历史输入内容显示
class HistoryBlock extends StatelessWidget {
  HistoryBlock({this.result});
  final Result result;
  @override
  Widget build(BuildContext context) {
    // 定义具体的显示内容
    var text = '';
    if(result.secondNum != null){
      text = '${result.firstNum}${result.oper.display}${result.secondNum}';
    }else if(result.oper != null){
      text = '${result.firstNum}${result.oper.display}';
    }else if(result.firstNum != null){
      text = '${result.firstNum}';
    }

    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 16, right: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: result.oper != null ? result.oper.color : Colors.white54,
           borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
         child: Text(text, style: TextStyle(fontSize: 30.0, color: Colors.black54),),
      ),
    );
  }
}