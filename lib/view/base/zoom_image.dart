import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ZoomPage extends StatefulWidget {
  final String placeholder;
  final String image;
  final double height;
  final double width;
  ZoomPage({@required this.placeholder,@required this.image, this.height, this.width });
  @override
  _ZoomPageState createState() => _ZoomPageState();
}

class _ZoomPageState extends State<ZoomPage> with SingleTickerProviderStateMixin {
 Animation _animation;
 AnimationController _animationController;
 @override
  void initState() {
    // TODO: implement initState
   _animationController = new AnimationController(vsync: this, duration: Duration(microseconds: 500));
   _animation = Tween(begin: 2.0, end: 3.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut))..addListener(() {
     setState(() {

     });
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onDoubleTap: (){
        if(_animationController.isCompleted){
          _animationController.reverse();
        } else{
          _animationController.forward();
        }
      },
      child: Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.diagonal3(Vector3(_animation.value, _animation.value, _animation.value,)),
          child: FadeInImage.assetNetwork(
            placeholder: widget.placeholder,
            image: widget.image,
            width: widget.width,
            height: widget.height,
              fit: BoxFit.fill)
      ),
    );
  }
}
