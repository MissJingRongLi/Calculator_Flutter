import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// typedef或为函数类型提供了在声明字段和返回类型时可以使用的名称
typedef void PressOperationCallback(Operator oper);

// 抽象类
abstract class Operator{
  String display;
  Color color;
  num calculator(num first, num second);
}

// 定义加法操作
class AddOperator extends Operator{
  @override
  String get display => '+';
  @override 
  // TODO: implement color
  Color get color => Colors.pink[300];
  @override 
  num calculator(first,second) {
    // TODO: implement calculator
    return first + second;
  }
}

// 定义 减法
class SubOperator extends Operator{
  @override 
  String get display => '-';
  @override 
  // TODO: implement color
  Color get color => Colors.orange[300];
  num calculator(first,second) {
    // TODO: implement calculator
    return first - second;
  }
}

// 定义 乘法
class MultiOperator extends Operator{
  @override 
  String get display => '*';
  @override 
  // TODO: implement color
  Color get color => Colors.lightBlue[300];
  num calculator(first,second) {
    // TODO: implement calculator
    return first * second;
  }
}

// 定义 除法
class DivisionOperator extends Operator{
  @override 
  String get display => '÷';
  @override 
  // TODO: implement color
  Color get color => Colors.purple[300];
  num calculator(first,second) {
    // TODO: implement calculator
    return first / second;
  }
}

// 把操作符放在一组里面
class OperatorGroup extends StatelessWidget {
  OperatorGroup(this.onOperatorButtonPressed);
  final PressOperationCallback onOperatorButtonPressed;
  @override
  Widget build(BuildContext context) {
    // 放在一行
    return Row(
      // 将 加减乘除 放在一起 作为子组件向页面填充
      children: <Widget>[
        OperatorButton(
          oper:AddOperator(),
          onPress: onOperatorButtonPressed,
        ),
        
        OperatorButton(
          oper:SubOperator(),
          onPress: onOperatorButtonPressed,
        ),
        
        OperatorButton(
          oper:MultiOperator(),
          onPress: onOperatorButtonPressed,
        ),
        
        OperatorButton(
          oper:DivisionOperator(),
          onPress: onOperatorButtonPressed,
        ),
        

      ],
    );
  }
}

class OperatorButton extends StatefulWidget {
  // 初始化传入的参数列表
  OperatorButton({@required this.oper, this.onPress}):assert(Operator != null);
  final Operator oper;
  final PressOperationCallback onPress;

  @override
  _OperatorButtonState createState() => _OperatorButtonState();
}

class _OperatorButtonState extends State<OperatorButton> {
  // 用于改变按钮点击时的颜色
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    //expanded 强制子组件填充可用空间
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: (){
            // 注册相关的点击事件
            if(widget.onPress != null){
              widget.onPress(widget.oper);
              setState(() {
               pressed = true; 
              });
              // 异步操作
              Future.delayed(
                const Duration(milliseconds: 200),
                () => setState((){
                  pressed = false;
                })
              );
            }
          },
          child: Container(
            // 摆放布局
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: pressed ? Color.alphaBlend(Colors.white30, widget.oper.color) : widget.oper.color,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
            ),
            // 符号颜色
            child: Text(
              '${widget.oper.display}',
              style: TextStyle(fontSize: 30.0, color: Colors.white),
            ),
          ),
        ),
      )
    );
  }
}